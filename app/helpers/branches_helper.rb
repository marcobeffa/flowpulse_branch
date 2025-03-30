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




  def full_tree_to_hash(branch)
    return {} if branch.nil?

    {
      id: branch.id,
      name: branch.slug.strip,
      visibilità: branch.visibility,
      pubblicato: branch.published,
      label: branch.label,
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
      name: "#{branch.slug.strip} [#{branch.visibility_icon} #{branch.published_icon}]",
      parent_links:  branch.parent_links.order(:position).map { |parent_link| parent_links_tree_to_hash(parent_link) },
      link_child_name: branch.child_link&.slug,
      link_child_id: branch.child_link&.id,
      children: branch.children.order(:position).where(label: false).map { |child| tree_to_hash(child) }
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
end
