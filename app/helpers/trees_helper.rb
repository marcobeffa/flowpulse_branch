module TreesHelper
  def embed_url(content)
    url = extract_video_url(content)
    return nil if url.blank?

    if url.include?("youtu.be")
      id = URI.parse(url).path[1..]
      "https://www.youtube.com/embed/#{id}"
    elsif url.include?("youtube.com")
      id = CGI.parse(URI.parse(url).query.to_s)["v"]&.first
      "https://www.youtube.com/embed/#{id}" if id
    elsif url.include?("vimeo.com")
      id = url[%r{vimeo\.com/(\d+)}, 1]
      "https://player.vimeo.com/video/#{id}" if id
    else
      nil
    end
  end

  def extract_video_url(content)
    if content.respond_to?(:video_url)
      content.video_url
    elsif content.is_a?(Hash)
      content["video_url"] || content[:video_url]
    else
      nil
    end
  end
end
