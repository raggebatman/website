##
# This class represents a shelf filled with books.
class Shelf

    ##
    # Specify a Nanoc @item or array of @item(s).
    # I recommend globbing the path if you're retreiving multiple files like so:
    # `Shelf.new(@items.find_all('/**/*.md'))`
    # This is done so we can easily read the file's metadata (frontmatter)
    def initialize(data)
        @books = Array.new

        if data.kind_of?(Array)
            data.each { |d| self.add_book(d.attributes) }
        else
            self.add_book(data.attributes)
        end
    end

    private def add_book(metadata)
        book = @books.find { |b| b.title == metadata[:book] }

        if book.nil?
            b = Book.new(metadata[:book])
            b.add_chapter(metadata)
            @books.append(b)
        else
            book.add_chapter(metadata)
        end
    end

    public def books
        return @books
    end
end

##
# This class represents data of a book in a shelf.
class Book
    def initialize(title)
        @title = title
        @chapters = Array.new
    end

    public def add_chapter(metadata)
        @chapters.append(Chapter.new(metadata))
    end

    public def chapters
        # sort the book before we return it since files will
        # be found in alphabetical order on the filesystem
        @chapters.sort_by! { |chapter| chapter.number }
        return @chapters
    end

    public def title
        return @title
    end
end

##
# This class represents data of a chapter in a book.
class Chapter
    def initialize(metadata)
        # original: `/content/.../file.md`
        #  returns: `/content/.../file.html`
        @hyperlink = metadata[:filename][7..-3] + 'html'
        @title = metadata[:chapter]
        @number = metadata[:number]
    end

    public def hyperlink
        return @hyperlink
    end

    public def title
        return @title
    end

    public def number
        return @number
    end
end