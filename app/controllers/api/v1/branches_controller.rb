class Api::V1::BranchesController < ApplicationController
  allow_unauthenticated_access only: %i[treepage menu fields content]

  def treepage
    branch = Branch.find_by(id: params[:id])
    if branch
      tree_hash = api_tree_to_hash_treepage(branch)
      json_string = tree_hash.to_json
      size_in_bytes = json_string.bytesize
      size_in_kb = (size_in_bytes / 1024.0).round(2)
      size_in_mb = (size_in_bytes / 1024.0 / 1024.0).round(2)

      tree_hash[:json_size_kb] = size_in_kb
      tree_hash[:json_warning] = "⚠️ Attenzione: dimensione JSON oltre 5 MB (#{size_in_mb} MB)" if size_in_mb > 5

      render json: tree_hash
    else
      render json: { error: "Branch not found" }, status: :not_found
    end
  end

  def menu
    branch = Branch.find_by(id: params[:id])
    if branch
      tree_hash = api_tree_to_hash_menu(branch)
      json_string = tree_hash.to_json
      size_in_bytes = json_string.bytesize
      size_in_kb = (size_in_bytes / 1024.0).round(2)
      size_in_mb = (size_in_bytes / 1024.0 / 1024.0).round(2)

      tree_hash[:json_size_kb] = size_in_kb
      tree_hash[:json_warning] = "⚠️ Attenzione: dimensione JSON oltre 5 MB (#{size_in_mb} MB)" if size_in_mb > 5

      render json: tree_hash
    else
      render json: { error: "Branch not found" }, status: :not_found
    end
  end

  def fields
    branch = Branch.find_by(id: params[:id])
    if branch
      tree_hash = api_tree_to_hash_fields(branch)
      json_string = tree_hash.to_json
      size_in_bytes = json_string.bytesize
      size_in_kb = (size_in_bytes / 1024.0).round(2)
      size_in_mb = (size_in_bytes / 1024.0 / 1024.0).round(2)

      tree_hash[:json_size_kb] = size_in_kb
      tree_hash[:json_warning] = "⚠️ Attenzione: dimensione JSON oltre 5 MB (#{size_in_mb} MB)" if size_in_mb > 5

      render json: tree_hash
    else
      render json: { error: "Branch not found" }, status: :not_found
    end
  end


  def content
    branch = Branch.find_by(id: params[:id])
    if branch
      tree_hash = api_tree_to_hash_content(branch)
      json_string = tree_hash.to_json
      size_in_bytes = json_string.bytesize
      size_in_kb = (size_in_bytes / 1024.0).round(2)
      size_in_mb = (size_in_bytes / 1024.0 / 1024.0).round(2)

      tree_hash[:json_size_kb] = size_in_kb
      tree_hash[:json_warning] = "⚠️ Attenzione: dimensione JSON oltre 5 MB (#{size_in_mb} MB)" if size_in_mb > 5

      render json: tree_hash
    else
      render json: { error: "Branch not found" }, status: :not_found
    end
  end



  private

  def api_tree_to_hash_treepage(branch)
    return {} unless branch

    tipo_branch = branch.child_link&.id && branch.child_link&.slug ? "link" : "treepage"

    base = {
      visibility: branch.visibility,
      branch_id: branch.id,
      name: branch.slug.strip,
      tipo: tipo_branch,
      updated_content: branch.updated_content,
      content: branch.content
    }

    if tipo_branch == "link"
      link_branch = Branch.find_by(id: branch.child_id)
      base.merge!(
        link_branch_id: branch.child_id,
        link_branch_name: link_branch&.slug&.strip
      )
    end

    if tipo_branch == "treepage"
      extra = {}

      extra[:parent_links] = branch.parent_links.order(:position).map do |pl|
        parent_links_tree_to_hash(pl)
      end

      extra[:fields] = branch.children
        .where(field: true, published: true)
        .where.not(visibility: "privato")
        .order(:position)
        .map do |field_branch|
          {
            visibility: field_branch.visibility,
            label: field_branch.slug,
            type: field_branch.field_type
          }
        end



      extra[:children] = branch.children
        .where(field: false, published: true)
        .where.not(visibility: "privato")
        .order(:position)
        .map { |child| api_tree_to_hash_treepage(child) }

      base.merge!(extra)
    end

    base
  end

  def parent_links_tree_to_hash(parent_link)
    return {} unless parent_link

    {
      # parent_link_id: parent_link.id,
      # parent_link_name: parent_link.slug,
      grand_parent_branch_id: parent_link.parent&.id,
      grand_parent_branch_name: parent_link.parent&.slug
    }
  end



  def api_tree_to_hash_menu(branch)
    return {} unless branch

    tipo_branch = branch.child_link&.id && branch.child_link&.slug ? "link" : "treepage"

    base = {
      visibility: branch.visibility,
      branch_id: branch.id,
      name: branch.slug.strip,
      tipo: tipo_branch
    }

    if tipo_branch == "link"
      link_branch = Branch.find_by(id: branch.child_id)
      base.merge!(
        link_branch_id: branch.child_id,
        link_branch_name: link_branch&.slug&.strip
      )
    end

    if tipo_branch == "treepage"
      extra = {}

      extra[:parent_links] = branch.parent_links.order(:position).map do |pl|
        parent_links_tree_to_hash(pl)
      end




      extra[:children] = branch.children
        .where(field: false, published: true)
        .where.not(visibility: "privato")
        .order(:position)
        .map { |child| api_tree_to_hash_menu(child) }

      base.merge!(extra)
    end

    base
  end



  def api_tree_to_hash_fields(branch)
    return {} unless branch

    tipo_branch = branch.child_link&.id && branch.child_link&.slug ? "link" : "treepage"

    base = {
      visibility: branch.visibility,
      branch_id: branch.id,
      name: branch.slug.strip,
      tipo: tipo_branch
    }


    if tipo_branch == "treepage"
      extra = {}

      extra[:parent_links] = branch.parent_links.order(:position).map do |pl|
        parent_links_tree_to_hash(pl)
      end

      extra[:fields] = branch.children
        .where(field: true, published: true)
        .where.not(visibility: "privato")
        .order(:position)
        .map do |field_branch|
          {
            visibility: field_branch.visibility,
            label: field_branch.slug,
            type: field_branch.field_type
          }
        end


      base.merge!(extra)
    end

    base
  end


  def api_tree_to_hash_content(branch)
    return {} unless branch

    tipo_branch = branch.child_link&.id && branch.child_link&.slug ? "link" : "treepage"

    base = {
      visibility: branch.visibility,
      branch_id: branch.id,
      name: branch.slug.strip,
      tipo: tipo_branch,
      updated_content: branch.updated_content,
      content: branch.content
    }




    base
  end
end
