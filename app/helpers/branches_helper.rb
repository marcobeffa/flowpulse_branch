module BranchesHelper
  def parent_chain(id)
    parent_ids = []
    branch = Branch.find_by(id: id)

    while branch&.parent_id
      parent_ids << branch.parent_id
      branch = Branch.find_by(id: branch.parent_id)
    end

    parent_ids.reverse
  end

  def tree_to_menu_hash(branch)
    return {} if branch.nil? || !branch.published

    {
      id: branch.id,
      name: branch.slug.strip,
      external_post_id: branch.external_post&.id,
      visibility: branch.visibility,
      published: branch.published,
      field: branch.field,
      updated_content: branch.updated_content,
      parent_links: branch.parent_links.order(:position).map { |parent_link| parent_links_tree_to_hash(parent_link) },
      link_child_name: branch.child_link&.slug,
      link_child_id: branch.child_link&.id,
      children: branch.children.order(:position).map { |child| full_tree_to_hash(child) }.reject { |child| child.empty? }
    }
  end

  def tree_to_menu_html(node)
    return "" if node.nil?

    # Crea l'elemento di lista per il nodo
    html = "<li><a href='##{node[:name].downcase.parameterize}'>#{node[:name]}</a>"

    # Se ci sono figli, crea un sottolista (ol)
    if node[:children].any?
      html += "<ol>"
      node[:children].each do |child|
        html += tree_to_menu_html(child)  # Chiamata ricorsiva per ogni figlio
      end
      html += "</ol>"
    end

    html += "</li>"
    html
  end


  def full_tree_to_hash(branch)
    return {} if branch.nil?

    {
      id: branch.id,
      name: branch.slug.strip,
      external_post_id: branch.external_post&.id,
      visibility: branch.visibility,
      published: branch.published,
      field: branch.field,
      updated_content: branch.updated_content,
      parent_links: branch.parent_links.order(:position).map { |parent_link| parent_links_tree_to_hash(parent_link) },
      link_child_name: branch.child_link&.slug,
      link_child_id: branch.child_link&.id,
      children: branch.children.order(:position).map { |child| full_tree_to_hash(child) }
    }
  end

  def tree_to_hash(branch)
    return {} if branch.nil?

    {
      id: branch.id,
      name: "#{branch.slug.strip} [#{branch.visibility_icon} #{branch.published_icon} #{branch.content_icon}]",
      parent_links:  branch.parent_links.order(:position).map { |parent_link| parent_links_tree_to_hash(parent_link) },
      link_child_name: branch.child_link&.slug,
      link_child_id: branch.child_link&.id,
      children: branch.children.order(:position).where(field: false).map { |child| tree_to_hash(child) }
    }
  end

  def parent_links_tree_to_hash(parent_link)
    return {} if parent_link.nil?
    {
    parent_link_id: (parent_link.id),
    parent_link_name: (parent_link.slug),
    grand_parent_id: (parent_link.parent.id if parent_link.parent.present?),
    grand_parent_name: (parent_link.parent.slug if parent_link.parent.present?)
    }
  end

  def hash_to_ascii(tree, prefix = "", parent_prefix = "", is_root = true)
    return "" if tree.nil? || tree.empty?

    output = ""

    # 1. Nodo corrente
    node_link = "<a href='/branches/#{tree[:id]}/mappa'>#{tree[:name]}</a>"
    if tree[:link_child_id]
      link_child = " - <a href='/branches/#{tree[:link_child_id]}/mappa'>#{tree[:link_child_name]}</a>"
    end

    # 2. Calcola righe parent_links (con la stessa indentazione del nodo)
    if tree[:parent_links].present?
      bullet_prefix = prefix.gsub(/(└──|├──)/, "│  ").gsub(/[^│]/, " ")

      tree[:parent_links].each_with_index do |link, index|
        is_last_link = index == tree[:parent_links].length - 1
        connector = index == 0 ? "┌──" : "├──"

        parent_link_html = "<a href='/branches/#{link[:parent_link_id]}'>#{link[:parent_link_name]}</a>"
        grand_parent_html = link[:grand_parent_name].present? ? "<a href='/branches/#{link[:grand_parent_id]}'>#{link[:grand_parent_name]}</a>" : ""

        output += "#{bullet_prefix}#{connector} #{parent_link_html} #{grand_parent_html}\n"
      end
    end

    # 3. Stampa il nodo
    output += is_root ? "#{node_link}\n" : "#{prefix}#{node_link}#{link_child}\n"

    # 4. Figli ricorsivi
    tree[:children].each_with_index do |child, index|
      is_last = index == tree[:children].length - 1
      child_prefix = parent_prefix + (is_last ? "└── " : "├── ")
      new_parent_prefix = parent_prefix + (is_last ? "    " : "│   ")

      output += hash_to_ascii(child, child_prefix, new_parent_prefix, false)
    end

    output
  end








  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    md = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    md.render(text).html_safe
  end

  # video
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
