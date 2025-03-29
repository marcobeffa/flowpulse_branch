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
      name: branch.slug.strip, # Rimuove spazi prima/dopo
      label: branch.label,
      children: branch.children.map { |child| full_tree_to_hash(child) }
    }
  end
  def tree_to_hash(branch)
    return {} if branch.nil?

    {
      id: branch.id,
      name: branch.slug.strip,  # Rimuove spazi prima/dopo
      children: branch.children.where(label: false).map { |child| tree_to_hash(child) }
    }
  end
  def hash_to_ascii(tree, prefix = "", parent_prefix = "", is_root = true)
    return "" if tree.nil? || tree.empty?

    node_link = "<a href='/branches/#{tree[:id]}/mappa'>#{tree[:name]}</a>"
    tree_content = is_root ? "#{node_link}\n" : "#{prefix}#{node_link}\n"

    tree[:children].each_with_index do |child, index|
      is_last = index == tree[:children].length - 1
      child_prefix = parent_prefix + (is_last ? "└── " : "├── ")
      new_parent_prefix = parent_prefix + (is_last ? "    " : "│   ")

      tree_content += hash_to_ascii(child, child_prefix, new_parent_prefix, false)
    end

    tree_content
  end


  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    md = Redcarpet::Markdown.new(renderer, autolink: true, tables: true)
    md.render(text).html_safe
  end
end
