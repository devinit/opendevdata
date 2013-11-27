class DatasetSerializer < ActiveModel::Serializer
  attributes :id, :name, :data_extract, :url

  #TODO -> test whether we need to include comments on data (i.e. what is the need by
  # by API consumers)
  # has_many :comments
  # belongs_to :organization # reference to the creating organization

  # The need for editing datasets programmatically through APIs has to be determined
  def attributes
    data = super
    if current_user.is_admin?  # scope to admin TODO-> decide other scopes
      data[:edit_url] = edit_dataset_url(object)
      data[:destroy_url] = dataset_url(object)
    end
    data
  end

  def url
    dataset_url object
  end
end
