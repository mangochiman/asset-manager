class AssetAttachment < ApplicationRecord
  self.table_name = 'asset_attachments'
  self.primary_key = 'asset_attachment_id'

  validate :file_storage_quota_validation, :file_size_validation

  def file_storage_quota_validation
    dirname = Rails.root.to_s + "/public/uploads/*"
    file_storage_in_bytes = Dir[dirname].select { |f|
      File.file?(f) }.sum { |f| File.size(f)
    }
    active_system_plan = SystemPlan.where('active =?', 1).last
    storage_quota = active_system_plan.storage_quota
    storage_quota_in_bytes = storage_quota * 1024 * 1024 * 1024 #from GB to Bytes

    if file_storage_in_bytes > storage_quota_in_bytes
      file_path = Rails.root.to_s + '/public' + self.url.to_s
      File.delete(file_path) if File.exist?(file_path)
      errors.add(:base, "Your current subscription allows maximum file storage of <b>#{storage_quota} GB</b>. Please upgrade your account")
    end
  end

  def file_size_validation
    uploaded_file_size_in_bytes = self.bytes
    uploaded_file_size_in_mb =  uploaded_file_size_in_bytes.to_f/( 1024 * 1024) #from bytes to MB
    max_file_size_quota_mb = User.max_file_size_quota_mb

    if uploaded_file_size_in_mb > max_file_size_quota_mb
      file_path = Rails.root.to_s + '/public' + self.url.to_s
      File.delete(file_path) if File.exist?(file_path)
      errors.add(:base, "Files bigger than <b>#{max_file_size_quota_mb} MB</b> are not accepted.")
    end
  end

end
