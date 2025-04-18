class Api::V1::TreesController < ApplicationController
  allow_unauthenticated_access only: [ :show ]
  def show
    branch = Branch.find_by(id: params[:id])
    if branch
      render json: api_full_tree_to_hash(branch)
    else
      render json: { error: "Branch not found" }, status: :not_found
    end
  end

  private

  def api_full_tree_to_hash(branch)
    return {} if branch.nil?
    {
      id: branch.id,
      name: branch.slug.strip, # Rimuove spazi prima/dopo
      external_post_id: branch.external_post&.id,
      label: branch.label,
      updated_content: branch.updated_content,
      parent_links:  branch.parent_links.order(:position).map { |parent_link| parent_links_tree_to_hash(parent_link) },
      link_child_name: branch.child_link&.slug,
      link_child_id: branch.child_link&.id,
      children: branch.children.where(visibility: "pubblico", published: true).order(:position).map { |child| api_full_tree_to_hash(child) }
    }
  end

  def parent_links_tree_to_hash(parent_link)
    return {} if parent_link.nil?
    {
    parent_link_id: (parent_link.id),
    parent_link_name: (parent_link.slug),
    parent_external_post_id: (parent_link.external_post&.id),
    grand_parent_id: (parent_link.parent.id if parent_link.parent.present?),
    grand_parent_name: (parent_link.parent.slug if parent_link.parent.present?)

  }
  end
end
