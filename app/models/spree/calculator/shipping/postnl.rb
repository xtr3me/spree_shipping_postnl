require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class Postnl < ShippingCalculator
      preference :postnl_letter_20g, :float, :default => 0.60
      preference :postnl_letter_50g, :float, :default => 1.20
      preference :postnl_letter_100g, :float, :default => 1.80
      preference :postnl_letter_250g, :float, :default => 2.40
      preference :postnl_letter_500g, :float, :default => 3.00
      preference :postnl_letter_2000g, :float, :default => 3.60
      preference :postnl_box_2000g, :float, :default => 6.75
      preference :postnl_box_5000g, :float, :default => 6.75
      preference :postnl_box_10000g, :float, :default => 6.75
      preference :postnl_box_20000g, :float, :default => 12.40
      preference :postnl_box_30000g, :float, :default => 12.40
      preference :oversized_class, :string, :default => 'postnl_box_2000g'
      preference :default_weight, :integer, :default => 0
      preference :default_height, :integer, :default => 0
      preference :default_width, :integer, :default => 0
      preference :default_depth, :integer, :default => 0

      # attr_accessible :preferred_postnl_letter_20g,
      #                 :preferred_postnl_letter_50g,
      #                 :preferred_postnl_letter_100g,
      #                 :preferred_postnl_letter_250g,
      #                 :preferred_postnl_letter_500g,
      #                 :preferred_postnl_letter_2000g,
      #                 :preferred_postnl_box_2000g,
      #                 :preferred_postnl_box_5000g,
      #                 :preferred_postnl_box_10000g,
      #                 :preferred_postnl_box_20000g,
      #                 :preferred_postnl_box_30000g,
      #                 :preferred_oversized_class,
      #                 :preferred_default_weight,
      #                 :preferred_default_height,
      #                 :preferred_default_width,
      #                 :preferred_default_depth

  def self.description
    Spree.t :postnl
  end

  def self.register
    super
  end

  def compute_package(package)
    content_items = package.contents
    return 0 unless content_items.size > 0

    weight = total_weight(content_items)
    volume = total_volume(content_items)
    di = max_dimensions(content_items)

    price = shipment_costs(weight, volume, di[:heigth], di[:width], di[:depth])

    return 0 unless price
    price
  end

  private
  def shipment_costs(weight, volume, heigth, width, depth)
    shipment_classes.each do |sc|
      if weight <= sc[:weight] && volume <= sc[:volume] && heigth <= sc[:heigth] && width <= sc[:width] && depth <= sc[:depth]
        return self.send("preferred_#{sc[:class]}".to_sym)
      end
    end
    return self.send("preferred_#{self.preferred_oversized_class}".to_sym)
  end

  def shipment_classes
    letter = { heigth: 380, width: 265, depth: 32, volume: 3222400 }
    little_box = { heigth: 1000, width: 500, depth: 500, volume: 250000000 }
    big_box = { heigth: 1750, width: 780, depth: 580, volume: 791700000 }
    [{ class: 'postnl_letter_20g',   weight: 20 }.merge!(letter),
     { class: 'postnl_letter_50g',   weight: 50 }.merge!(letter),
     { class: 'postnl_letter_100g',  weight: 100 }.merge!(letter),
     { class: 'postnl_letter_250g',  weight: 250 }.merge!(letter),
     { class: 'postnl_letter_500g',  weight: 500 }.merge!(letter),
     { class: 'postnl_letter_2000g', weight: 2000 }.merge!(letter),
     { class: 'postnl_box_2000g',    weight: 2000 }.merge!(little_box),
     { class: 'postnl_box_5000g',    weight: 5000 }.merge!(little_box),
     { class: 'postnl_box_10000g',   weight: 10000 }.merge!(little_box),
     { class: 'postnl_box_20000g',   weight: 20000 }.merge!(big_box),
     { class: 'postnl_box_30000g',   weight: 30000 }.merge!(big_box)]
  end

  def total_weight(content_items)
    weight = 0
    content_items.each do |item|
      weight += item.quantity * weight(item.variant.weight)
    end
    weight
  end

  def total_volume(content_items)
    volume = 0
    content_items.each do |item|
      volume += item.quantity * (height(item.variant.height) * width(item.variant.width) * depth(item.variant.depth))
    end
    volume
  end

  def max_dimensions(content_items)
    dimensions = { heigth: 0, width: 0, depth: 0 }
    content_items.each do |item|
      if dimensions[:heigth] < height(item.variant.height)
        dimensions[:heigth] = height(item.variant.height)
      end

      if dimensions[:width] < width(item.variant.width)
        dimensions[:width] = width(item.variant.width)
      end

      if dimensions[:depth] < depth(item.variant.depth)
        dimensions[:depth] = depth(item.variant.depth)
      end
    end
    dimensions
  end

  def height(size)
    size_or_default(size, 'height')
  end

  def width(size)
    size_or_default(size, 'width')
  end

  def depth(size)
    size_or_default(size, 'depth')
  end

  def weight(size)
    size_or_default(size, 'weight')
  end

  def size_or_default(size, type)
    (size ? size : self.send("preferred_default_#{type}".to_sym))
  end

    end
  end
end
