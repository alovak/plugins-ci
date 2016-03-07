require 'spec_helper'

describe 'store customer' do
  before :all do
    visit "/index.php/admin/"
    fill_in "User Name", with: "demo"
    fill_in "Password", with: "demo123"
    click_on "Login"
    within("#nav") { click_on "System" }
    click_on "Configuration"
    click_on "Payment Methods"

    # expand Start Payment Gateway Module"
    find("#payment_gateway-head").click

    select "Yes", from: "Enable Test Mode"
    select "Yes", from: "Enabled"
    fill_in "Title", with: "Credit / Debit Card"
    fill_in "Test Open Key", with: "test_open_k_c3f462a1e8277114c1da"
    fill_in "Test Secret Key", with: "test_sec_k_16dc38ad730d6ba806a92"
    fill_in "Live Open Key", with: "test_open_k_c3f462a1e8277114c1da"
    fill_in "Live Secret Key", with: "test_sec_k_16dc38ad730d6ba806a92"
    select "US Dollar", from: "Currency"
    select "United Arab Emirates Dirham", from: "Currency"
    select "Authorize and Capture", from: "Payment Action"
    select "Complete", from: "New Order Status"
    within("#content") { click_on "Save Config" }
    expect(page).to have_text("The configuration has been saved.")
  end

  it 'pays successfully for order' do
    visit "/index.php/demo-product.html"
    expect(page).to have_text "Demo Description"

    click_on "Add to Cart"
    expect(page).to have_content "Demo Product was added to your shopping cart."

    visit "/index.php/checkout/onepage/"

    choose "Checkout as Guest"
    click_on "Continue"

    fill_in "First Name", with: "Abdullah"
    fill_in "Last Name", with: "Ahmed"
    fill_in "Email Address", with: "start@payfort.com"
    find("input[title='Street Address']").set "In the middle of something"
    fill_in "City", with: "Dubai"
    fill_in "Telephone", with: "+1-555-555-555"
    select "United Arab Emirates", from: "Country"
    fill_in "Zip", with: "12345"
    click_on "Continue"
    sleep 1

    # shipping information
    click_on "Continue"
    sleep 1

    choose "Credit / Debit Card"

    click_on "Continue"

    in_frame do
      expect(page).to have_text("Secured with 128bit SSL encryption")
      expect(find("#email").value).to eq("start@payfort.com")

      fill_inputmask('#number', '4242424242424242')
      fill_inputmask('#expiry', '11/22')
      fill_inputmask('#cvc', '123')

      click_on "Ok"
      sleep 5
    end
    # expect(page).to have_text("Pay with Card: xxxx-xxxx-xxxx-4242")

    # click_on "Continue"
    # sleep 1

    click_on "Place Order"

    sleep 2

    expect(page).to have_content("YOUR ORDER HAS BEEN RECEIVED.")
  end

  it 'receives decline when charge declined' do
    visit "/index.php/demo-product.html"
    expect(page).to have_text "Demo Description"

    click_on "Add to Cart"
    expect(page).to have_content "Demo Product was added to your shopping cart."

    visit "/index.php/checkout/onepage/"

    choose "Checkout as Guest"
    click_on "Continue"

    fill_in "First Name", with: "Abdullah"
    fill_in "Last Name", with: "Ahmed"
    fill_in "Email Address", with: "start@payfort.com"
    find("input[title='Street Address']").set "In the middle of something"
    fill_in "City", with: "Dubai"
    fill_in "Telephone", with: "+1-555-555-555"
    select "United Arab Emirates", from: "Country"
    fill_in "Zip", with: "12345"
    click_on "Continue"
    sleep 1

    # shipping information
    click_on "Continue"
    sleep 1

    choose "Credit / Debit Card"

    click_on "Continue"

    in_frame do
      expect(page).to have_text("Secured with 128bit SSL encryption")
      expect(find("#email").value).to eq("start@payfort.com")

      fill_inputmask('#number', '4000000000000002')
      fill_inputmask('#expiry', '11/22')
      fill_inputmask('#cvc', '123')

      click_on "Ok"
      sleep 5
    end

    click_on "Place Order"


    sleep 2
    expect(page.driver.browser.switch_to.alert.text).to eq('Charge was declined. Please, contact you bank for more information or use a different card.')
    page.driver.browser.switch_to.alert.accept

    sleep 1

    expect(page).to have_selector('li#opc-payment.active')

    # second attempt
    #
    choose "Credit / Debit Card"

    click_on "Continue"

    in_frame do
      expect(page).to have_text("Secured with 128bit SSL encryption")
      expect(find("#email").value).to eq("start@payfort.com")

      fill_inputmask('#number', '4242424242424242')
      fill_inputmask('#expiry', '11/22')
      fill_inputmask('#cvc', '123')

      click_on "Ok"
      sleep 5
    end

    click_on "Place Order"

    sleep 2

    expect(page).to have_content("YOUR ORDER HAS BEEN RECEIVED.")
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
    if (Capybara.default_driver == :selenium)
      value.split('').each { |c| find(location).native.send_keys(c) }
    else
      script = "$('#{location}').val('#{value}');"
      page.evaluate_script(script)
    end
  end

  def in_frame(&block)
    if (Capybara.default_driver == :selenium)
      within_frame("beautifulJs", &block)
    else
      yield
    end
  end
end
