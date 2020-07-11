require 'rails_helper'
require 'rake'

describe "Merchants API" do

  before :each do 
    FactoryBot.reload

    # @merchant1 = create(:merchant, id: )
    # @merchant2 = create(:merchant, id: 2)
    
    # 10.times do 
    #   create(:item, merchant: @merchant2)
    #   create(:item, merchant: @merchant1)
    # end

  end

  it "Can get a merchant" do
    merchant1 = create(:merchant, id: 42, name: "Glover Inc")
    merchant2 = create(:merchant, id: 43, name: "Booter Inc")

    get '/api/v1/merchants/42'

    expected_attributes = {
      name: 'Glover Inc',
    }

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data][:id]).to eq('42')

    expected_attributes.each do |attribute, value|
      expect(json[:data][:attributes][attribute]).to eq(value)
    end
  end

  it 'can get a merchant' do
    100.times do 
      create(:merchant)
    end

    get '/api/v1/merchants'
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].length).to eq(100)
    json[:data].each do |merchant|
      expect(merchant[:type]).to eq("merchant")
      expect(merchant[:attributes]).to have_key(:name)
    end
  end

  it 'can create and delete a merchant' do
    name = "Dingle Hoppers"

    body = {
      name: name
    }

    # Create a merchant
    post '/api/v1/merchants', params: body

    json = JSON.parse(response.body, symbolize_names: true)

    new_merchant = json[:data]

    expect(new_merchant[:attributes][:name]).to eq(name)

    # Delete a merchant
    delete "/api/v1/merchants/#{new_merchant[:id]}"

    json = JSON.parse(response.body, symbolize_names: true)

    deleted_merchant = json[:data]
    expect(deleted_merchant[:attributes][:name]).to eq(name)
  end

  it 'can update a merchant' do
    create(:merchant, id: 98)
    create(:merchant, id: 99, name: 'dog')

    get '/api/v1/merchants/99'

    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data][:attributes][:name]).to eq('dog')


    new_name = "Dingle Hoppers"

    body = {
      name: new_name,
    }

    patch'/api/v1/merchants/99', params: body

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]
    expect(merchant[:attributes][:name]).to eq(new_name)
  end


end




# end
# end

# describe 'Relationships' do
# it 'can get items for a merchant' do
# response = conn('/api/v1/merchants/99/items').get
# json = JSON.parse(response.body, symbolize_names: true)
# expected_ids =
# [
#   2397, 2398, 2399, 2400, 2401, 2402, 2403, 2404, 2405, 2406,
#   2407, 2408, 2409, 2410, 2411, 2412, 2413, 2414, 2415, 2416,
#   2417, 2418, 2419, 2420, 2421, 2422, 2423, 2424, 2425, 2426,
#   2427, 2428, 2429, 2430, 2431, 2432, 2433, 2434, 2435, 2436,
#   2437, 2438
# ]
# item_ids = json[:data].map do |item|
#   item[:id].to_i
# end
# expect(item_ids.sort).to eq(expected_ids)
# end

# it 'can get merchant for an item' do
# response = conn('/api/v1/items/209/merchant').get
# json = JSON.parse(response.body, symbolize_names: true)
# expected_id = '11'

# expect(json[:data][:id]).to eq(expected_id)
# end
# end

# describe "search endpoints" do
# it 'can find a list of merchants that contain a fragment, case insensitive' do
# response = conn('/api/v1/merchants/find_all?name=ILL').get
# json = JSON.parse(response.body, symbolize_names: true)

# names = json[:data].map do |merchant|
#   merchant[:attributes][:name]
# end

# expect(names.sort).to eq(["Schiller, Barrows and Parker", "Tillman Group", "Williamson Group", "Williamson Group", "Willms and Sons"])
# end

# it 'can find a merchants that contain a fragment, case insensitive' do
# response = conn('/api/v1/merchants/find?name=ILL').get
# json = JSON.parse(response.body, symbolize_names: true)
# name = json[:data][:attributes][:name].downcase

# expect(json[:data]).to be_a(Hash)
# expect(name).to include('ill')
# end

# it 'can find a list of items that contain a fragment, case insensitive' do
# response = conn('/api/v1/items/find_all?name=haru').get
# json = JSON.parse(response.body, symbolize_names: true)

# names = json[:data].map do |merchant|
#   merchant[:attributes][:name].downcase
# end

# expect(names.count).to eq(18)
# names.each do |name|
#   expect(name).to include('haru')
# end
# end

# it 'can find an items that contain a fragment, case insensitive' do
# response = conn('/api/v1/items/find?name=haru').get
# json = JSON.parse(response.body, symbolize_names: true)
# name = json[:data][:attributes][:name].downcase

# expect(json[:data]).to be_a(Hash)
# expect(name).to include('haru')
# end
# end

# describe 'business intelligence' do
# it 'can get merchants with most revenue' do
# response = conn("/api/v1/merchants/most_revenue?quantity=7").get
# json = JSON.parse(response.body, symbolize_names: true)

# expect(json[:data].length).to eq(7)

# expect(json[:data][0][:attributes][:name]).to eq("Dicki-Bednar")
# expect(json[:data][0][:id]).to eq("14")

# expect(json[:data][3][:attributes][:name]).to eq("Bechtelar, Jones and Stokes")
# expect(json[:data][3][:id]).to eq("10")

# expect(json[:data][6][:attributes][:name]).to eq("Rath, Gleason and Spencer")
# expect(json[:data][6][:id]).to eq("53")
# end

# it 'can get merchants who have sold the most items' do
# response = conn("/api/v1/merchants/most_items?quantity=8").get

# json = JSON.parse(response.body, symbolize_names: true)

# expect(json[:data].length).to eq(8)

# expect(json[:data][0][:attributes][:name]).to eq("Kassulke, O'Hara and Quitzon")
# expect(json[:data][0][:id]).to eq("89")

# expect(json[:data][3][:attributes][:name]).to eq("Okuneva, Prohaska and Rolfson")
# expect(json[:data][3][:id]).to eq("98")

# expect(json[:data][7][:attributes][:name]).to eq("Terry-Moore")
# expect(json[:data][7][:id]).to eq("84")
# end

# it 'can get revenue between two dates' do
# response = conn('/api/v1/revenue?start=2012-03-09&end=2012-03-24').get

# json = JSON.parse(response.body, symbolize_names: true)

# expect(json[:data][:attributes][:revenue].to_f.round(2)).to eq(43201227.80)
# end
# end