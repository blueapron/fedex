require 'spec_helper'

module Fedex
  describe TrackingInformation do
    let(:fedex) { Shipment.new(fedex_credentials) }

    context "shipments with tracking number", :vcr, :focus do
      subject(:tracking_info) { fedex.track(options) }

      let(:tracking_number) { '122816215025810' }

      let(:options) do
        {
          :package_id   => tracking_number,
          :package_type => "TRACKING_NUMBER_OR_DOORTAG",
        }
      end

      it "reports the status of the package" do
        tracking_info = fedex.track(options)

        expect(tracking_info).to have_attributes(
          service_type:    "FEDEX_GROUND",
          signature_name:  "ROLLINS",
          status:          "Delivered",
          tracking_number: "122816215025810"
        )
      end

      it "returns events with tracking information" do
        expect(tracking_info.events.count).to eq 1
      end

      context "with short hand tracking number queries" do
        let(:options) { { :tracking_number => tracking_number } }

        it "tracks correctly" do
          expect(tracking_info.tracking_number).to eq tracking_number
        end
      end

      context 'with invalid package type' do
        before { options[:package_type] = "UNKNOWN_PACKAGE" }

        it 'raises an error' do
          expect { subject }.to raise_error(RuntimeError, "Unknown package type 'UNKNOWN_PACKAGE'")
        end
      end
    end
  end
end