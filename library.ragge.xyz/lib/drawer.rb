##
# This class represents a drawer filled with articles.
class Drawer

    ##
    # Specify a Nanoc @item or array of @item(s).
    # I recommend globbing the path if you're retreiving multiple files like so:
    # `Drawer.new(@items.find_all('/**/*.md'))`
    # This is done so we can easily read the file's metadata (frontmatter)
    def initialize(data)
        @articles = Array.new

        if data.kind_of?(Array)
            data.each { |d| self.add_article(d.attributes) }
        else
            self.add_article(data.attributes)
        end
    end

    private def add_article(metadata)
        @articles.append(Article.new(metadata))
    end

    public def articles
        return @articles
    end
end

##
# This class represents data of an article in a drawer.
class Article
    def initialize(metadata)
        # original: `/content/.../file.md`
        #  returns: `/content/.../file.html`
        @hyperlink = metadata[:filename][7..-3] + 'html'
        @title = metadata[:title]
    end

    public def hyperlink
        return @hyperlink
    end

    public def title
        return @title
    end
end