class HtmlPrettyPrinter < Nanoc::Filter
    identifier :pp_html

    def run(content, _params = {})
        require 'htmlbeautifier'
        content = HtmlBeautifier.beautify(content)
    end
end