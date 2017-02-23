require 'spec_helper'

describe 'something' do
  before :all do
    visit "/wp-login.php"
    fill_in "Username", with: "demo"
    fill_in "Password", with: "demo"
    click_on "Log In"
    expect(page).to have_text('Welcome to WordPress')

    visit "/wp-admin/plugins.php"
    expect(page).to have_selector('h1', text: 'Plugins')

    within("tr[data-slug=payfort]") do
      click_on  "Activate"
    end

    wait_until do
      expect(page).to have_text('Plugin activated')
    end

    # Configure
    visit "/wp-admin/admin.php?page=wc-settings&tab=checkout&section=wc_gateway_payfort"
    expect(page).to have_selector('h3', text: 'Payfort Start')

    check "Enable/Disable"

    fill_in "Test Open Key", with: "test_open_k_c3f462a1e8277114c1da"
    fill_in "Test Secret Key", with: "test_sec_k_16dc38ad730d6ba806a92"
    fill_in "Live Open Key", with: "test_open_k_c3f462a1e8277114c1da"
    fill_in "Live Secret Key", with: "test_sec_k_16dc38ad730d6ba806a92"
    check "Test mode"
    click_on "Save changes"

    expect(page).to have_text("Your settings have been saved.")
  end

  it 'should do' do
    visit "/product/demo"
    expect(page).to have_text 'Demo Description'

    within("form.cart") { click_on "Add to cart" }

    wait_until do
      expect(page).to have_text("has been added to your cart")
    end

    visit "/checkout"
    expect(page).to have_text("Billing Details")

    fill_in "First Name", with: "Abdullah"
    fill_in "Last Name", with: "Ahmed"
    fill_in "Email Address", with: "start@payfort.com"
    fill_in "Phone", with: "+1-555-555-555"

    within("#billing_address_1_field") { fill_in "Address", with: "In the middle of something" }
    fill_in "Town / City", with: "Dubai"
    fill_in "State", with: "Dubai"

    expect(page).to have_text("You're in test mode. Make sure to use test cards to checkout")

    click_on "Place order"

    sleep 2

    within_frame(0) do
      expect(page).to have_text("Secure Payment Form")

      fill_inputmask('#number', '4242424242424242')
      fill_inputmask('#expiry', '11/22')
      fill_inputmask('#cvc', '123')
      find("button.btn-submit").click
    end

    wait_until do
      expect(page).to have_text("Your order has been received")
    end
  end

  def fill_inputmask(location, value)
    value.split('').each { |c| find(location).native.send_keys(c) }
  end

  def wait_until
    attempts ||= 5
    yield
  rescue Exception
    sleep 1
    puts "retry..."
    (attempts -= 1).zero? ? raise : retry
  end
end
