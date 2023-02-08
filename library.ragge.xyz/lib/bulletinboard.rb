##
# This class represents a bulletin board filled with notes.
class BulletinBoard

    ##
    # Specify a Nanoc @item or array of @item(s).
    # I recommend globbing the path if you're retreiving multiple files like so:
    # `BulletinBoard.new(@items.find_all('/**/*.md'))`
    # This is done so we can easily read the file's metadata (frontmatter)
    def initialize(data)
        @notes = Array.new

        if data.kind_of?(Array)
            data.each { |d| self.add_note(d.attributes) }
        else
            self.add_note(data.attributes)
        end
    end

    private def add_note(metadata)
        @notes.append(Note.new(metadata))
    end

    public def notes
        return @notes
    end
end

##
# This class represents data of a note on a bulletin board.
class Note
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