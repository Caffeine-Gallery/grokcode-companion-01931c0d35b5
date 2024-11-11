import Char "mo:base/Char";
import Iter "mo:base/Iter";

import Text "mo:base/Text";
import Error "mo:base/Error";
import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Nat8 "mo:base/Nat8";
import Nat "mo:base/Nat";

actor {
    stable var apiKey : Text = "";

    public func setApiKey(key : Text) : async () {
        apiKey := key;
    };

    public shared(msg) func sendMessageToGrok(message : Text) : async Text {
        if (apiKey == "") {
            throw Error.reject("API key not set");
        };

        let url = "https://api.x.ai/v1/chat/completions";
        let body = "{\"model\":\"grok-beta\",\"messages\":[{\"role\":\"user\",\"content\":\"" # message # "\"}]}";

        let headers = [
            ("Content-Type", "application/json"),
            ("Authorization", "Bearer " # apiKey)
        ];

        try {
            let response = await httpRequest(url, "POST", headers, Blob.toArray(Text.encodeUtf8(body)));

            switch (response.status) {
                case (200) {
                    let responseBody = Text.decodeUtf8(Blob.fromArray(response.body));
                    switch (responseBody) {
                        case (?text) {
                            // Parse the JSON response to extract the message content
                            let pattern = #text "\"content\":\"";
                            let endPattern = #text "\",\"";

                            let startIndex = switch (Text.split(text, pattern).next()) {
                                case (null) { null };
                                case (?value) { ?Text.size(value) };
                            };

                            let endIndex = switch (startIndex) {
                                case (null) { null };
                                case (?start) {
                                    switch (Text.split(textSlice(text, start, Text.size(text)), endPattern).next()) {
                                        case (null) { null };
                                        case (?value) { ?(start + Text.size(value)) };
                                    };
                                };
                            };

                            switch (startIndex, endIndex) {
                                case (?start, ?end) {
                                    let content = textSlice(text, start, end);
                                    return content;
                                };
                                case (_) {
                                    return "Failed to parse Grok response";
                                };
                            };
                        };
                        case (null) {
                            return "Failed to decode response body";
                        };
                    };
                };
                case (code) {
                    return "Unexpected response code from Grok: " # debug_show(code);
                };
            };
        } catch (e) {
            Debug.print("Error calling Grok API: " # Error.message(e));
            return "Error: Failed to communicate with Grok";
        };
    };

    private func httpRequest(url : Text, method : Text, headers : [(Text, Text)], body : [Nat8]) : async {status : Nat; headers : [{ name : Text; value : Text }]; body : [Nat8]} {
        let request_headers = Buffer.Buffer<{ name : Text; value : Text }>(0);
        for ((name, value) in headers.vals()) {
            request_headers.add({ name = name; value = value });
        };

        let ic : actor { 
            http_request : {
                url : Text;
                method : Text;
                body : [Nat8];
                headers : [{ name : Text; value : Text }];
            } -> async {
                status : Nat;
                headers : [{ name : Text; value : Text }];
                body : [Nat8];
            };
        } = actor("aaaaa-aa");

        let response = await ic.http_request({
            url = url;
            method = method;
            body = body;
            headers = request_headers.toArray();
        });

        return {
            status = response.status;
            headers = response.headers;
            body = response.body;
        };
    };

    private func textSlice(t : Text, start : Nat, end : Nat) : Text {
        let chars = Text.toArray(t);
        let size = chars.size();
        let slice = Array.tabulate(Nat.sub(Nat.min(end, size), start), func (i : Nat) : Char {
            chars[start + i]
        });
        Text.fromIter(slice.vals())
    };
}
