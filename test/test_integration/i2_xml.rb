#!/usr/bin/env ruby
# IntegrationTestI2Xml -- xmlconv2 -- 30.06.2004 -- hwyss@ywesee.com

$: << File.dirname(__FILE__)
$: << File.expand_path('../../src', File.dirname(__FILE__))

require 'test/unit'
require 'util/transaction'
require 'util/destination'
require 'conversion/bdd_xml'
require 'conversion/i2_bdd'
require 'mock'

module XmlConv
	module Util
		class DestinationHttp < Destination
			HTTP_CLASS = Mock.new('DestinationHttp::HTTP_CLASS')
		end
	end
	module Integration
		class TestI2Xml < Test::Unit::TestCase
			def setup
				@src = <<-EOS
"00" "Sender Identification" "Recipient Identification" 
	"20040628" "1159" "CONFIRM" "1"
"01" "456" "Receipt-Number" "20040627" "20040629" "Order Number" 
	"Commission Number" "OC" "Employee" "TE" "0041 1 350 85 87" 
"02" "BY" "Name1" "Name2" "Street" "City" "AddressCode" "Country"
"02" "SE" "Name1" "Name2" "Street" "City" "AddressCode" "Country"
"02" "DP" "Name1" "Name2" "Street" "City" "AddressCode" "Country"
"05" "A single Header-Text"
"05" "Another single Header-Text"
"10" "10" "EAN13" "IdSeller" "IdBuyer" "Description 1" 
	"Description 2" "2" "Commission" "20040630" "QuantityUnit"
	"PriceUnit" "1" "2" "0.1" "0.2" "0.2" "0.4" "0.7" "1.4" "VAT" 
	"OriginCountry" "Customs"
"15" "A single Position-Text"
"15" "Another single Position-Text"
"10" "20" "EAN13" "IdSeller" "IdBuyer" "Description 1" 
	"Description 2" "2" "Commission" "20040630" "QuantityUnit"
	"PriceUnit" "1" "2" "0.1" "0.2" "0.2" "0.4" "0.7" "1.4" "VAT" 
	"OriginCountry" "Customs"
"15" "Yet Another single Position-Text"
"10" "30" "EAN13" "IdSeller" "IdBuyer" "Description 1" 
	"Description 2" "2" "Commission" "20040630" "QuantityUnit"
	"PriceUnit" "1" "2" "0.1" "0.2" "0.2" "0.4" "0.7" "1.4" "VAT" 
	"OriginCountry" "Customs"
"90" "4.2" "7.6" "0.32" "4.52" "Agreement"
				EOS
				@ast = Conversion::I2Bdd.parse(@src)
			end
			def test_i2_xml
				bdd = Conversion::I2Bdd.convert(@ast)
				xml = Conversion::BddXml.convert(bdd)
				assert_instance_of(REXML::Document, xml)
				expected = <<-EOS
  <?xml version='1.0' encoding='UTF-8'?>
  <!DOCTYPE BDD SYSTEM "ABB BDD.dtd">
  <BDD>
    <BSR>
      <Timestamp Zone='+2'>20040628115900</Timestamp>
      <Verb>Return</Verb>
      <Noun>Status</Noun>
      <Party Role='Customer' Version='2'>
        <PartyId Domain='ACC'>Sender Identification</PartyId>
      </Party>
    </BSR>
    <Delivery>
      <Status Date='20040627'>Confirmed</Status>
      <DeliveryId Domain='Customer'>Commission Number</DeliveryId>
      <DeliveryId Domain='ACC'>Order Number</DeliveryId>
      <Party Role='Seller' Version='2'>
        <Address>
          <AddressLine>Name1</AddressLine>
          <AddressLine>Name2</AddressLine>
          <AddressLine>Street</AddressLine>
          <City>City</City>
          <ZipCode Domain='Country'>AddressCode</ZipCode>
        </Address>
      </Party>
      <Party Role='Customer' Version='2'>
        <Party Role='Employee' Version='2'>
          <Name>Employee</Name>
        </Party>
        <Party Role='BillTo' Version='2'>
          <Address>
            <AddressLine>Name1</AddressLine>
            <AddressLine>Name2</AddressLine>
            <AddressLine>Street</AddressLine>
            <City>City</City>
            <ZipCode Domain='Country'>AddressCode</ZipCode>
          </Address>
        </Party>
        <Party Role='ShipTo' Version='2'>
          <Address>
            <AddressLine>Name1</AddressLine>
            <AddressLine>Name2</AddressLine>
            <AddressLine>Street</AddressLine>
            <City>City</City>
            <ZipCode Domain='Country'>AddressCode</ZipCode>
          </Address>
        </Party>
      </Party>
      <DeliveryItem>
        <LineNo>10</LineNo>
        <PartId>
          <IdentNo Domain='ET-Nummer'>EAN13</IdentNo>
          <IdentNo Domain='ACC'>IdBuyer</IdentNo>
          <IdentNo Domain='Lieferantenartikel'>IdSeller</IdentNo>
        </PartId>
        <Qty>2</Qty>
        <Price Purpose='NettoPreis'>1.00</Price>
        <Price Purpose='NettoPreisME'>2.00</Price>
        <Price Purpose='Grundrabatt'>0.10</Price>
        <Price Purpose='GrundrabattME'>0.20</Price>
        <Price Purpose='Sonderrabatt'>0.20</Price>
        <Price Purpose='SonderrabattME'>0.40</Price>
        <Price Purpose='BruttoPreis'>0.70</Price>
        <Price Purpose='BruttoPreisME'>1.40</Price>
        <FreeText Type='Bezeichnung'>Description 1
Description 2</FreeText>
        <DeliveryDate>20040630</DeliveryDate>
      </DeliveryItem>
      <DeliveryItem>
        <LineNo>20</LineNo>
        <PartId>
          <IdentNo Domain='ET-Nummer'>EAN13</IdentNo>
          <IdentNo Domain='ACC'>IdBuyer</IdentNo>
          <IdentNo Domain='Lieferantenartikel'>IdSeller</IdentNo>
        </PartId>
        <Qty>2</Qty>
        <Price Purpose='NettoPreis'>1.00</Price>
        <Price Purpose='NettoPreisME'>2.00</Price>
        <Price Purpose='Grundrabatt'>0.10</Price>
        <Price Purpose='GrundrabattME'>0.20</Price>
        <Price Purpose='Sonderrabatt'>0.20</Price>
        <Price Purpose='SonderrabattME'>0.40</Price>
        <Price Purpose='BruttoPreis'>0.70</Price>
        <Price Purpose='BruttoPreisME'>1.40</Price>
        <FreeText Type='Bezeichnung'>Description 1
Description 2</FreeText>
        <DeliveryDate>20040630</DeliveryDate>
      </DeliveryItem>
      <DeliveryItem>
        <LineNo>30</LineNo>
        <PartId>
          <IdentNo Domain='ET-Nummer'>EAN13</IdentNo>
          <IdentNo Domain='ACC'>IdBuyer</IdentNo>
          <IdentNo Domain='Lieferantenartikel'>IdSeller</IdentNo>
        </PartId>
        <Qty>2</Qty>
        <Price Purpose='NettoPreis'>1.00</Price>
        <Price Purpose='NettoPreisME'>2.00</Price>
        <Price Purpose='Grundrabatt'>0.10</Price>
        <Price Purpose='GrundrabattME'>0.20</Price>
        <Price Purpose='Sonderrabatt'>0.20</Price>
        <Price Purpose='SonderrabattME'>0.40</Price>
        <Price Purpose='BruttoPreis'>0.70</Price>
        <Price Purpose='BruttoPreisME'>1.40</Price>
        <FreeText Type='Bezeichnung'>Description 1
Description 2</FreeText>
        <DeliveryDate>20040630</DeliveryDate>
      </DeliveryItem>
      <Price Purpose='SummePositionen'>4.20</Price>
      <Price Purpose='MehrwertsteuerPct'>7.60</Price>
      <Price Purpose='Mehrwertsteuer'>0.32</Price>
      <Price Purpose='Endbetrag'>4.51</Price>
      <FreeText>A single Header-Text
Another single Header-Text</FreeText>
      <Agreement>
        <TermsCond>Agreement</TermsCond>
      </Agreement>
    </Delivery>
  </BDD>

				EOS
				assert_equal(expected, xml.to_s(1))
			end
		end
	end
end
