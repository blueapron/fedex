require 'spec_helper'

module Fedex
  describe Address, :production do
    describe "validation" do

      # Address Validation is only enabled in the production environment
      #
      let(:fedex) { Shipment.new(fedex_production_credentials) }

      context "valid address", :vcr do
        let(:address) do
          {
            :street      => "5 Elm Street",
            :city        => "Norwalk",
            :state       => "CT",
            :postal_code => "06850",
            :country     => "USA"
          }
        end

        let(:options) do
          { :address => address }
        end

        it "validates the address" do
          address = fedex.validate_address(options)

          expect(address).to have_attributes(
            residential: true,
            business:    false,
            score:       100,
            postal_code: "06850-3901"
          )
        end
      end

    end
  end
end