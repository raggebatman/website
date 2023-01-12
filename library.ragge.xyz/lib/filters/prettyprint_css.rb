class CssPrettyPrinter < Nanoc::Filter
    identifier :pp_css

    def run(content, _params = {})
        require 'cssbeautify'
        content = CssBeautify.beautify(content)
    end
end