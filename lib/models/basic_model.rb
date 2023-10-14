module BasicModel
  def create_or_update(hash)
    hash.select! {|k, _v| self.column_names.include? k }
    obj = self.find_or_initialize_by(id: hash['id'])
    obj.attributes = hash
    obj.save(:validate => false)
  end
end
