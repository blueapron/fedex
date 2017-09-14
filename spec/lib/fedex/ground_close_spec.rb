require 'spec_helper'

module Fedex
  describe GroundClose do
    describe "close" do
      let(:fedex) { Shipment.new(fedex_credentials) }

      context "when valid", :vcr do
        it "returns manifest" do
          ground_close = fedex.close
          ground_close.manifest.should_not == nil
        end
      end
    end
  end
end