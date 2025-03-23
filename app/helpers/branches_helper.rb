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
  def tree_to_hash(branch)
    return {} if branch.nil?

    {
      id: branch.id,  # <-- Aggiunto ID per il link corretto
      name: branch.slug,
      icon: branch.mycategory&.icon || "\u2796",
      children: branch.children.map { |child| tree_to_hash(child) }
    }
  end
  def hash_to_ascii(tree, prefix = "", parent_prefix = "")
    return "" if tree.nil? || tree.empty?

    # Creiamo un link con l'ID corretto del nodo
    node_link = "#{tree[:icon]} #{tree[:name]}"
    tree_content = "#{prefix}#{node_link}\n"

    tree[:children].each_with_index do |child, index|
      is_last = index == tree[:children].length - 1
      child_prefix = parent_prefix + (is_last ? "└── " : "├── ")
      new_parent_prefix = parent_prefix + (is_last ? "    " : "│   ")

      tree_content += hash_to_ascii(child, child_prefix, new_parent_prefix)
    end

    tree_content
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    md = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    md.render(text).html_safe
  end
end
