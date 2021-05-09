module WebpackBundleHelper
  class BundleNotFound < StandardError; end

  def asset_bundle_path(entry, **options)
    raise BundleNotFound, "Could not find bundle with name #{entry}" unless manifest.key? entry
    asset_path(manifest.fetch(entry), **options)
  end

  def asset_bundle_url(entry, **options)
    raise BundleNotFound, "Could not find bundle with name #{entry}" unless manifest.key? entry
    asset_url(manifest.fetch(entry), **options)
  end

  def javascript_bundle_tag(entry, **options)
    # skip when not generate split chunk
    return if entry == 'vendor' && !manifest.key?("#{entry}.js")

    path = asset_bundle_path("#{entry}.js")

    options = {
      src: path,
      defer: true
    }.merge(options)

    options.delete(:defer) if options[:async]

    javascript_include_tag '', **options
  end

  def stylesheet_bundle_tag(entry, **options)
    path = asset_bundle_path("#{entry}.css")
    options = { href: path }.merge(options)

    stylesheet_link_tag '', **options
  end

  def image_bundle_tag(entry, **options)
    raise ArgumentError, "Extname is missing with #{entry}" unless File.extname(entry).present?
    image_tag asset_bundle_path(entry), **options
  end

  def lazy_image_bundle_tag(entry, **options)
    raise ArgumentError, "Extname is missing with #{entry}" unless File.extname(entry).present?

    lazyload = { class: 'lazyload' }
    options = options.merge(lazyload) do |key, oldval, newval|
      key == :class ? "lazyload #{oldval}" : newval
    end
    tag.img 'data-src': asset_bundle_path(entry), **options
  end

  private

  MANIFEST_PATH = 'public/bundles/manifest.json'.freeze

  def manifest
    @manifest ||= JSON.parse(File.read(MANIFEST_PATH))
  end
end
