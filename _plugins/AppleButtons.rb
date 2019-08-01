
##
## Installation:
## Place in _plugins/AppleButtons.rb
##


##
## Usage: {% OpenAppleButton %}
##

class OpenAppleButtonTag < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
  end

  def render(context)
    output =  "<img style=\"width:24px; height:24px;\" src=\"/pix/OpenAppleButton.svg\" onerror=\"this.onerror=null; this.src='/pix/OpenAppleButton-24x24.png'\" />"

    return output;
  end
end
Liquid::Template.register_tag('OpenAppleButton', OpenAppleButtonTag)


##
## Usage: {% ClosedAppleButton %}
##

class ClosedAppleButtonTag < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
  end

  def render(context)
    output =  "<img style=\"width:24px; height:24px;\" src=\"/pix/ClosedAppleButton.svg\" onerror=\"this.onerror=null; this.src='/pix/ClosedAppleButton-24x24.png'\" />"

    return output;
  end
end
Liquid::Template.register_tag('ClosedAppleButton', ClosedAppleButtonTag)


##
## Usage: {% EscAppleButton %}
##

class EscAppleButtonTag < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
  end

  def render(context)
    output =  "<img style=\"width:24px; height:24px;\" src=\"/pix/EscAppleButton.svg\" onerror=\"this.onerror=null; this.src='/pix/EscAppleButton-24x24.png'\" />"

    return output;
  end
end
Liquid::Template.register_tag('EscAppleButton', EscAppleButtonTag)


##
## Usage: {% QAppleButton %}
##

class QAppleButtonTag < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
  end

  def render(context)
    output =  "<img style=\"width:24px; height:24px;\" src=\"/pix/QAppleButton.svg\" onerror=\"this.onerror=null; this.src='/pix/QAppleButton-24x24.png'\" />"

    return output;
  end
end
Liquid::Template.register_tag('QAppleButton', QAppleButtonTag)
