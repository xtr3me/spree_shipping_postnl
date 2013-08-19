require 'spec_helper'

module Spree
  module Calculator::Shipping
    describe Postnl do
      let(:variant1) { build(:variant, { price: 10, width: 20, height: 30, depth: 8, weight: 40 }) }
      let(:variant2) { build(:variant, { price: 10, width: 20, height: 30, depth: 8, weight: 60 }) }
      let(:variant3) { build(:variant, { price: 10, width: 50000, height: 30000, depth: 80000, weight: 400000 }) }
      let(:variant4) { build(:variant, { price: 10, width: 4321, height: 6543, depth: 4321, weight: 1234 }) }
      
      let(:empty_package) { mock(Stock::Package,
                        order: mock_model(Order),
                        contents: []) }
                        
      let(:letter_50g) { mock(Stock::Package,
                          order: mock_model(Order),
                          contents: [Stock::Package::ContentItem.new(variant1, 1)]
                          )}
                                   
      let(:letter_200g) { mock(Stock::Package,
                           order: mock_model(Order),
                           contents: [Stock::Package::ContentItem.new(variant1, 1),
                                      Stock::Package::ContentItem.new(variant2, 2)]
                           )}
                           
      let(:box_sized) { mock(Stock::Package,
                           order: mock_model(Order),
                           contents: [Stock::Package::ContentItem.new(variant1, 1),
                                      Stock::Package::ContentItem.new(variant4, 2)]
                           )}
                           
      let(:oversized) { mock(Stock::Package,
                           order: mock_model(Order),
                           contents: [Stock::Package::ContentItem.new(variant1, 4),
                                      Stock::Package::ContentItem.new(variant2, 6),
                                      Stock::Package::ContentItem.new(variant3, 6)]
                           )}

      let(:subject) { Postnl.new }
      
      context "compute" do
        it "should compute amount correctly when using an empty package" do
          subject.compute_package(empty_package).round(3).should == 0.0
        end
        
        it "should compute amount correctly when using a 50g letter package" do
          subject.compute_package(letter_50g).round(3).should == 1.20
        end
        
        it "should compute amount correctly when using a 200g letter package" do
           subject.compute_package(letter_200g).round(3).should == 2.40
        end
        
        it "should compute amount correctly when using a 160g box sized package" do
           subject.compute_package(box_sized).round(3).should == 6.75
        end        
        
        it "should compute amount correctly when using a oversized package" do
          subject.compute_package(oversized).round(3).should == 6.75
        end        
      end
      
      context "i18e" do
        it "should display PostNL when using the en locale" do
          subject.description.should == "PostNL"
        end
      end
    end
  end
end
