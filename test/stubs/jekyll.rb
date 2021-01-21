# Tools to stub the jekyll and liquid interfaces
module Stubs
  include Presets
  include Structs

  def context
    @context ||= build_context
  end

  def build_context
    environments = [{ 'jekyll' => { 'environment' => jekyll_env } }]
    registers = {
      site: site,
      page: page
    }

    ContextStub.new(environments, registers)
  end

  def site
    @site ||= SiteStub.new(jconfig, data, site_source, site_dest, cache_dir)
  end

  def stub_liquid
    stub_liquid_tag
    stub_template_parsing
  end

  def stub_liquid_tag
    Liquid::Template.stubs(:register_tag)
  end

  # Stubs the following:
  # Liquid::Template.parse(params).render(context)
  # Returns whatever params are originally passed in.
  def stub_template_parsing
    template_stub = Object.new
    Liquid::Template.stubs(:parse).with do |params|
      template_stub.stubs(:render).returns(params)
    end.returns(template_stub)
  end
end
