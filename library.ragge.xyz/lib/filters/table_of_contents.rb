class TableOfContentsGenerator < Nanoc::Filter
    identifier :add_toc

    def run(content, _params = {})
        require 'nokogiri'

        document = Nokogiri::HTML5(content)

        def query
            ((1..4).map { |n| "main h#{n}" }).join(', ')
        end

        headings = document.css(query);
        headings.sort()

        res = ''

        unless headings.empty?
            def get_size(thing)
                # extracts this part in square brackets:
                # <h[1]>...</h1>
                thing.to_s()[2..3].to_i()
            end

            def get_link(thing)
                "<a href=\"##{thing['id']}\">#{thing.text}</a>"
            end

            toc = ''

            headings.each do | heading |
                i = headings.index(heading)

                # these vars will hold the number in the heading
                # i.e. if the current {heading} contains '<h2>...' then {cur == 2}
                # so remember; the higher the number, the smaller the heading
                cur = get_size(heading)
                prv = nil
                nxt = nil
                
                # just implement some checks to make sure
                # we don't over/underflow
                unless i <= 0
                    prv = get_size(headings[i - 1])
                end

                unless i >= headings.length - 1
                    nxt = get_size(headings[i + 1])
                end

                #puts "prv=#{prv}, cur=#{cur}, nxt=#{nxt}"

                # let's get to putting this together!
                # for reference regarding the formatting of the html:
                # https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Counter_Styles/Using_CSS_counters

                link = get_link(heading)

                if !nxt.nil?
                    if nxt == cur
                        # the next heading is of the same size so,
                        # we don't need to do anything special here
                        toc += "<li>#{link}</li>"
                    end
    
                    if nxt > cur
                        # we're going down a level on the next iteration so,
                        # make sure we leave this <li> open
                        # (the h level doesn't matter because we expect it to be
                        # just one level down, e.g. going from h2 to h3)
                        toc += "<li>#{link}<ol>"
                    end
    
                    if nxt < cur
                        # we're going up a level on the next iteration so,
                        # make sure we terminate the <li> and <ol> appropriately,
                        # taking into account how many levels we travel
                        # (i.e. going from h4 to h2 or the like)
                        toc += "<li>#{link}</li>" + ('</ol></li>' * (cur - nxt))
                    end
                else
                    # this is our final item
                    toc += "<li>#{link}</li>"
                    
                    if cur > 1
                        # make sure to close off any sections
                        # in case this isn't a h1
                        toc += '</ol></li>' * (cur - 1)
                    end
                end
            end

            res = '<ol id="toc">' + toc + '</ol>'
        end
        
        content.gsub('{{TOC}}', res)
    end
end
