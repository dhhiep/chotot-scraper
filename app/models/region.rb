class Region < ApplicationRecord
  has_many :areas, primary_key: :region_id
  has_many :accounts, primary_key: :region_id

  def self.regions_areas_v2(reload: false)
    @region_v2 = nil if reload # force reload
    return @region_v2 if @region_v2

    regions = JSON.parse(File.read(Rails.root.join('config', 'regions_and_areas.json')))
    @region_v2 =
      regions.inject([]) do |result, data|
        info = {}
        areas = data[1].symbolize_keys
        info[:region_id] = data[0]
        info[:region_name] = areas[:name]
        info[:areas] = areas[:area].values.map { |area| area.merge(region_id: info[:region_id]).symbolize_keys }
        result << info
      end
  end

  def self.regions_v2(reload: false)
    @regions_v2 = nil if reload
    @regions_v2 ||= regions_areas_v2(reload: reload).map do |e|
      {region_id: e[:region_id], region_name: e[:region_name]}
    end
  end

  def self.get_areas_by_region_v2(region_id)
    areas_v2.select{|region| region[:region_id] == region_id.to_s}
  end

  def self.areas_v2(reload: false)
    @all_areas_v2 = nil if reload
    @all_areas_v2 ||= regions_areas_v2(reload: reload).map{|e| e[:areas]}.flatten
  end
end
