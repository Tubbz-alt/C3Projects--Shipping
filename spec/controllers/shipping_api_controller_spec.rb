require 'rails_helper'

RSpec.describe ShippingApiController, type: :controller do

  describe "POST rate_compare" do
    let(:params) {
      { origin: { zip: "98101", city: "Seattle", state: "WA", country: "US"},
        destination: { city: "Beaverton", state: "OR", zip: 97005, country: "USA" },
        package: { weight: 12, dimensions: [15, 10, 4.5], units: :imperial }
      }
    }

    before :each do
      post :rates, params
    end

    context "when params are valid" do
      it "is successful" do
        expect(response.response_code).to eq(200)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      describe "the returned json object" do
        before :each do
          @object = JSON.parse(response.body)
        end

        it "is an array of hashes"

        it "includes only service, price, and delivery_date"
      end
    end
  end

  describe "POST create_log" do
    context "request is valid" do
      before :each do
        @params = attributes_for(:log)
        post :create_log, { log: @params }
      end

      it "returns a 200 (ok)" do
        expect(response.response_code).to eq(200)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      it "persists a log in the db" do
        expect(Log.count).to eq(1)
      end

      describe "returned json object" do
        let(:object) { JSON.parse(response.body) }

        it "includes the log" do
          log = Log.find_by(@params)
          (@params.keys).each do |key|
            expect(object[key.to_s]).to eq log[key]
          end
        end
      end
    end

    context "request is invalid" do
      before :each do
        post :create_log, { log: attributes_for(:log, customer: nil) }
      end

      it "returns a 400 (bad request)" do
        expect(response.response_code).to eq(400)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      describe "returned json object" do
        let(:object) { JSON.parse(response.body) }

        it "includes the error messages" do
          expect(object).to eq({"customer"=>["can't be blank"]})
        end
      end
    end
  end
end
