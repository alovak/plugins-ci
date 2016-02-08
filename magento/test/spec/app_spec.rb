require 'spec_helper'
require 'byebug'

describe 'store customer' do
  before :all do
    # visit "/wp-login.php"
    # fill_in "Username", with: "demo"
    # fill_in "Password", with: "demo"
    # click_on "Log In"
    # visit "/wp-admin/plugins.php"
    # within("#payfort-start") do
    #   click_on  "Activate"
    # end

    # # Configure
    # visit "/wp-admin/admin.php?page=wc-settings&tab=checkout&section=wc_gateway_payfort"
    # check "Enable/Disable"
    # fill_in "Test Open Key", with: "test_open_k_c3f462a1e8277114c1da"
    # fill_in "Test Secret Key", with: "test_sec_k_16dc38ad730d6ba806a92"
    # fill_in "Live Open Key", with: "test_open_k_c3f462a1e8277114c1da"
    # fill_in "Live Secret Key", with: "test_sec_k_16dc38ad730d6ba806a92"
    # check "Test mode"
    # click_on "Save changes"

    # expect(page).to have_text("Your settings have been saved.")
  end

  it 'pays for order' do
    visit "/index.php/demo-product.html"
    expect(page).to have_text "Demo Description"

    click_on "Add to Cart"
    expect(page).to have_content "Demo Product was added to your shopping cart."

    visit "/index.php/checkout/onepage/"

    choose "Checkout as Guest"
    click_on "Continue"

    byebug
    a = 1
    fill_in "First Name", with: "Abdullah"
    fill_in "Last Name", with: "Ahmed"
    fill_in "Email Address", with: "start@payfort.com"
    fill_in "Address", with: "In the middle of something"
    find("input[title='Street Address']").set "In the middle of something"
    fill_in "City", with: "Dubai"
    fill_in "Telephone", with: "+1-555-555-555"
    select "United Arab Emirates", from: "Country"
    fill_in "Zip", with: "12345"
    click_on "Continue"

    # choose "Credit / Debit Card"

    # click_on "Place order"

    # # within_frame("name#beautifulJs") do
    # expect(page).to have_text("Secured with 128bit SSL encryption")
    # expect(find("#email").value).to eq("start@payfort.com")

    # fill_inputmask('#number', '4242424242424242')
    # fill_inputmask('#expiry', '11/22')
    # fill_inputmask('#cvc', '123')
    # # page.save_screenshot "screenshoot1.png", full: true

    # # click_on "Pay AED 15.00"
    # find("button.btn-submit").click
    # sleep 10

    # expect(page).to have_content("Order Received")
  end

  def select2(value, attrs)
    first("#s2id_#{attrs[:from]}").click
    sleep(1)
    find(".select2-input").set(value)
    within ".select2-result" do
      find("span", text: value).click
    end
  end

  def fill_inputmask(location, value)
    # value.split('').each { |c| find(location).native.send_keys(c) }

    script = "$('#{location}').val('#{value}');"
    page.evaluate_script(script)
  end
end
