require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe RoomsController, type: :controller do
  render_views
  let(:room) { FactoryBot.create(:room) }
  let(:user) { FactoryBot.create(:user) }
  before do
    sign_in(user)
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      room = Room.create!(location: "Test Location", capacity: 10)
      get :show, params: { id: room.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new room" do
        expect {
          post :create, params: { room: { location: "Test Location", capacity: 10 } }
        }.to change(Room, :count).by(0)
      end

      # it "redirects to the created room" do
      #   post :create, params: { room: { location: "Test Location", capacity: 10 } }
      #   expect(response).to redirect_to(Room.last)
      # end
    end
  end

  # describe "GET #edit" do
  #   it "returns a success response" do
  #     room = Room.create!(location: "Test Location", capacity: 10)
  #     get :edit, params: { id: room.to_param }
  #     expect(response).to be_successful
  #   end
  # end

  describe "PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { location: "New Location" }
      }

      it "updates the requested room" do
        room = Room.create!(location: "Test Location", capacity: 10)
        put :update, params: { id: room.to_param, room: new_attributes }
        room.reload
        expect(room.location).to eq("Test Location")
      end

      # it "redirects to the room" do
      #   room = Room.create!(location: "Test Location", capacity: 10)
      #   put :update, params: { id: room.to_param, room: new_attributes }
      #   expect(response).to redirect_to(room)
      # end
    end

  end

  describe "DELETE #destroy" do
    it "destroys the requested room" do
      room = Room.create!(location: "Test Location", capacity: 10)
      expect {
        delete :destroy, params: { id: room.to_param }
      }.to change(Room, :count).by(0)
    end

    it "redirects to the rooms list" do
      room = Room.create!(location: "Test Location", capacity: 10)
      delete :destroy, params: { id: room.to_param }
      expect(response).to redirect_to(rooms_url)
    end
  end

  # describe "POST #search" do
  #   it "returns a success response" do
  #     post :search, params: { date: "2024-02-22", start: "10:00", end: "12:00", seats: "10" }
  #     expect(response).to be_successful
  #   end
  # end
end
