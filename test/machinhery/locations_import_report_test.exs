defmodule Geolocation.Machinery.LocationsImportReportTest do
  use ExUnit.Case, async: false

  alias Geolocation.Machinery.LocationsImportReport

  describe "report_accepted/1" do
    test "the default increment number" do
      %LocationsImportReport{accepted: 0} = LocationsImportReport.get_report()

      LocationsImportReport.report_accepted()

      assert %LocationsImportReport{accepted: 1} = LocationsImportReport.get_report()

      LocationsImportReport.report_accepted()

      assert %LocationsImportReport{accepted: 2} = LocationsImportReport.get_report()

      LocationsImportReport.clear_report()
    end

    test "a number to be added into the accepted state" do
      %LocationsImportReport{accepted: 0} = LocationsImportReport.get_report()

      LocationsImportReport.report_accepted(2)

      assert %LocationsImportReport{accepted: 2} = LocationsImportReport.get_report()

      LocationsImportReport.report_accepted(3)

      assert %LocationsImportReport{accepted: 5} = LocationsImportReport.get_report()

      LocationsImportReport.clear_report()
    end
  end

  describe "report_discarded/1" do
    test "the default increment number" do
      %LocationsImportReport{discarded: 0} = LocationsImportReport.get_report()

      LocationsImportReport.report_discarded()

      assert %LocationsImportReport{discarded: 1} = LocationsImportReport.get_report()

      LocationsImportReport.report_discarded()

      assert %LocationsImportReport{discarded: 2} = LocationsImportReport.get_report()

      LocationsImportReport.clear_report()
    end

    test "a number to be added into the accepted state" do
      %LocationsImportReport{discarded: 0} = LocationsImportReport.get_report()

      LocationsImportReport.report_discarded(2)

      assert %LocationsImportReport{discarded: 2} = LocationsImportReport.get_report()

      LocationsImportReport.report_discarded(3)

      assert %LocationsImportReport{discarded: 5} = LocationsImportReport.get_report()

      LocationsImportReport.clear_report()
    end
  end

  describe "report_noop/1" do
    test "the default increment number" do
      %LocationsImportReport{noop: 0} = LocationsImportReport.get_report()

      LocationsImportReport.report_noop()

      assert %LocationsImportReport{noop: 1} = LocationsImportReport.get_report()

      LocationsImportReport.report_noop()

      assert %LocationsImportReport{noop: 2} = LocationsImportReport.get_report()

      LocationsImportReport.clear_report()
    end

    test "a number to be added into the accepted state" do
      %LocationsImportReport{noop: 0} = LocationsImportReport.get_report()

      LocationsImportReport.report_noop(2)

      assert %LocationsImportReport{noop: 2} = LocationsImportReport.get_report()

      LocationsImportReport.report_noop(3)

      assert %LocationsImportReport{noop: 5} = LocationsImportReport.get_report()

      LocationsImportReport.clear_report()
    end
  end

  describe "clear_report" do
    test "the report reset behavior" do
      LocationsImportReport.report_accepted()
      LocationsImportReport.report_discarded()
      LocationsImportReport.report_noop()

      %LocationsImportReport{accepted: 1, discarded: 1, noop: 1} =
        LocationsImportReport.get_report()

      LocationsImportReport.clear_report()

      %LocationsImportReport{accepted: 0, discarded: 0, noop: 0} =
        LocationsImportReport.get_report()
    end
  end
end
