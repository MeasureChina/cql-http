require "./spec_helper"

describe CQL_HTTP do
  describe "Query" do
    it "should parse_cql_select" do
      q0 = File.read("./spec/fixtures/result_select_0")
      parsed = CQL_HTTP::Query.parse_cql_select q0
      
      parsed["count"].should eq(4)
      parsed["columns"].size.should eq(3)
      parsed["columns"][0].should eq("id")
      
      parsed["rows"].size.should eq(4)
      parsed["rows"][2][1].should eq("/hello/ | pipe |")
    end
  end
end
