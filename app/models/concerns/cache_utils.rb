##
# キャッシュ共通
# Usage example:
#  include CacheUtils
##
module CacheUtils
  extend ActiveSupport::Concern

  module ClassMethods
    # class_name_method_name_id
    # ex.) easy_trade_spending_capacity_1
    def cache_key(method_name, id)
      "#{self.to_s.underscore}_#{method_name}_#{id}"
    end

    # @param[Lambda] キャッシュするデータを取得するもの
    # @param[Integer] キャッシュのキーとするオブジェクトID
    def cache_fetch(obj, obj_id)
      Rails.cache.fetch(cache_key(caller_locations(1).first.label, obj_id)) do
        obj.call
      end
    end
  end

  def delete_cache
    self.class::DELETE_CACHE_METHODS.each do |v|
      method_name = v.keys.first
      key_id = v.values.first
      Rails.cache.delete(self.class.cache_key(
        method_name.to_s,
        eval("self.#{key_id.to_s}")
      ))
    end
  end
end
