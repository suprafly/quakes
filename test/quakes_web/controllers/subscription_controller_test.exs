defmodule QuakesWeb.SubscriptionControllerTest do
  use QuakesWeb.ConnCase

  describe "/subscriptions" do
    test "POST a valid subscription payload without filters and verify the response", %{conn: conn} do
      endpoint = "https://receiver.mywebservice.com/earthquakes"
      payload = %{"endpoint" => endpoint}

      conn = post(conn, ~p"/subscriptions", payload)
      assert %{
        "id" => _id,
        "start" => _start,
        "details" => %{
          "endpoint" => ^endpoint,
          "filters" => []
        }
      } = json_response(conn, 200)
    end

    test "POST a valid subscription payload with a filter and verify the response", %{conn: conn} do
      endpoint = "https://receiver.mywebservice.com/earthquakes"
      payload = %{
        "endpoint" => endpoint,
        "filters" => [
          %{
            "type" => "magnitude",
            "minimum" => 1.0
          }
        ]
      }

      conn = post(conn, ~p"/subscriptions", payload)
      assert %{
        "id" => _id,
        "start" => _start,
        "details" => %{
          "endpoint" => ^endpoint,
          "filters" => [
            %{
              "type" => "magnitude",
              "minimum" => 1.0
            }
          ]
        }
      } = json_response(conn, 200)
    end

    test "POST a valid subscription payload with multiple filters and verify the response", %{conn: conn} do
      endpoint = "https://receiver.mywebservice.com/earthquakes"
      payload = %{
        "endpoint" => endpoint,
        "filters" => [
          %{
            "type" => "magnitude",
            "minimum" => 1.0
          },
           %{
              "type" => "magnitude",
              "maximum" => 4.0
            },
            %{
              "type" => "place",
              "match" => "CA$"
            }
        ]
      }

      conn = post(conn, ~p"/subscriptions", payload)
      assert %{
        "id" => _id,
        "start" => _start,
        "details" => %{
          "endpoint" => ^endpoint,
          "filters" => [
            %{
              "type" => "magnitude",
              "minimum" => 1.0
            },
            %{
              "type" => "magnitude",
              "maximum" => 4.0
            },
            %{
              "type" => "place",
              "match" => "CA$"
            }
          ]
        }
      } = json_response(conn, 200)
    end

    test "POST an invalid subscription payload - no data", %{conn: conn} do
      conn = post(conn, ~p"/subscriptions", %{})
      assert %{
        "errors" => %{"endpoint" => ["can't be blank"]}
      } = json_response(conn, 422)
    end

    test "POST an invalid subscription payload - invalid endpoint", %{conn: conn} do
      payload = %{"endpoint" => "endpoint"}
      conn = post(conn, ~p"/subscriptions", payload)
      assert %{
        "errors" => %{"endpoint" => ["must be a valid url"]}
      } = json_response(conn, 422)
    end

    test "POST an invalid subscription payload - invalid minimum filter", %{conn: conn} do
      payload = %{
        "endpoint" => "https://receiver.mywebservice.com/earthquakes",
        "filters" => [
          %{
            "type" => "magnitude",
            "minimum" => "1.0"
          }
        ]
      }
      conn = post(conn, ~p"/subscriptions", payload)
      assert %{
        "errors" => %{"filters" => [%{"minimum" => "must have a value that is a number (integer or float)"}]}
      } = json_response(conn, 422)
    end

    test "POST an invalid subscription payload - invalid maximum filter", %{conn: conn} do
      payload = %{
        "endpoint" => "https://receiver.mywebservice.com/earthquakes",
        "filters" => [
          %{
            "type" => "magnitude",
            "maximum" => "1.0"
          }
        ]
      }
      conn = post(conn, ~p"/subscriptions", payload)
      assert %{
        "errors" => %{"filters" => [%{"maximum" => "must have a value that is a number (integer or float)"}]}
      } = json_response(conn, 422)
    end

    test "POST an invalid subscription payload - invalid equal filter", %{conn: conn} do
      payload = %{
        "endpoint" => "https://receiver.mywebservice.com/earthquakes",
        "filters" => [
          %{
            "type" => "magnitude",
            "equal" => "1.0"
          }
        ]
      }
      conn = post(conn, ~p"/subscriptions", payload)
      assert %{
        "errors" => %{"filters" => [%{"equal" => "must have a value that is a number (integer or float)"}]}
      } = json_response(conn, 422)
    end

    test "POST an invalid subscription payload - invalid match filter", %{conn: conn} do
      payload = %{
        "endpoint" => "https://receiver.mywebservice.com/earthquakes",
        "filters" => [
          %{
            "type" => "place",
            "match" => "*CA"
          }
        ]
      }
      conn = post(conn, ~p"/subscriptions", payload)
      assert %{
        "errors" => %{"filters" => [%{"match" => "is an invalid regex"}]}
      } = json_response(conn, 422)
    end
  end
end
