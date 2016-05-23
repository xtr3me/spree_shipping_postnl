require 'spec_helper'

module Spree
  module Calculator::Shipping
    describe Postnl do

      def build_content_items(variant, quantity, order)
        quantity.times.map {|i| Spree::Stock::ContentItem.new(build_inventory_unit(variant, order)) }
      end

      def build_inventory_unit(variant, order)
        build(:inventory_unit, variant: variant, order: order)
      end

      let(:country)  { FactoryGirl.create(:country, :name => "Nederland", :iso => "NL12") }
      let(:address)  { mock_model(Spree::Address, :country => country, :state_name => nil, :city => "Amsterdam", :zipcode => "1111 AA", :state => nil) }
      let(:order)    { mock_model(Spree::Order, :ship_address => address) }
      let(:variant1) { build(:variant, { price: 10, width: 20, height: 30, depth: 8, weight: 40 }) }
      let(:variant2) { build(:variant, { price: 10, width: 20, height: 30, depth: 8, weight: 60 }) }
      let(:variant3) { build(:variant, { price: 10, width: 50000, height: 30000, depth: 80000, weight: 400000 }) }
      let(:variant4) { build(:variant, { price: 10, width: 4321, height: 6543, depth: 4321, weight: 1234 }) }
      
      let(:empty_package) { double(Stock::Package,
                        order: double(Order),
                        contents: []) }
                        
      let(:letter_50g) { double(Stock::Package,
                          order: order,
                          contents: [
                            build_content_items(variant1, 1, order) 
                          ].flatten
                          )}
                                   
      let(:letter_200g) { double(Stock::Package,
                           order: double(Order),
			   contents: [
                             build_content_items(variant1, 1, order),
                             build_content_items(variant2, 2, order)
                           ].flatten
                           )}
                           
      let(:box_sized) { double(Stock::Package,
                           order: double(Order),
                           contents: [
                             build_content_items(variant1, 1, order),
                             build_content_items(variant4, 2, order)
                           ].flatten
                           )}
                           
      let(:oversized) { double(Stock::Package,
                           order: double(Order),
                           contents: [
                             build_content_items(variant1, 4, order),
                             build_content_items(variant2, 6, order),
                             build_content_items(variant3, 6, order)
			   ].flatten
                           )}

      let(:subject) { Postnl.new }
      
      context "compute" do
        it "should compute amount correctly when using an empty package" do
          expect(subject.compute_package(empty_package).round(3)).to eq(0.0)
        end
        
        it "should compute amount correctly when using a 50g letter package" do
          expect(subject.compute_package(letter_50g).round(3)).to eq(1.46)
        end
        
        it "should compute amount correctly when using a 200g letter package" do
           expect(subject.compute_package(letter_200g).round(3)).to eq(2.92)
        end
        
        it "should compute amount correctly when using a 160g box sized package" do
           expect(subject.compute_package(box_sized).round(3)).to eq(6.95)
        end        
        
        it "should compute amount correctly when using a oversized package" do
          expect(subject.compute_package(oversized).round(3)).to eq(6.95)
        end        
      end
      
      context "i18e" do
        it "should display PostNL when using the en locale" do
          expect(subject.description).to eq("PostNL")
        end
      end
    end
  end
end
