// Copyright (c) 2024 WSO2 LLC. (http://www.wso2.org).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Configurations related to authentication.
public type CredentialsConfig record {|
    # Salesforce login username
    string username;
    # Salesforce login password appended with the security token (<password><security token>)
    string password;
|};

# Salesforce listener configuration.
public type ListenerConfig record {|
    # Configurations related to username/password authentication
    CredentialsConfig auth;
    # The replay ID to change the point in time when events are read
    int|ReplayOptions replayFrom = REPLAY_FROM_TIP;
    # The type of salesforce environment, if sandbox environment or not
    boolean isSandBox = false;
|};

# The replay options representing the point in time when events are read.
public enum ReplayOptions {
    # To get all new events sent after subscription. This option is the default
    REPLAY_FROM_TIP,
    # To get all new events sent after subscription and all past events within the retention window
    REPLAY_FROM_EARLIEST
}

# Contains data returned from a Change Data Event.
public type EventData record {
    # A JSON map which contains the changed data
    map<json> changedData;
    # Header fields that contain information about the event
    ChangeEventMetadata metadata?;
};

# Header fields that contain information about the event.
public type ChangeEventMetadata record {
    # The date and time when the change occurred, represented as the number of milliseconds since January 1, 1970 00:00:00 GMT
    int commitTimestamp?;
    # Uniquely identifies the transaction that the change is part of
    string transactionKey?;
    # Origin of the change. Use this field to find out what caused the change.
    string changeOrigin?;
    # The operation that caused the change
    string changeType?;
    # The name of the standard or custom object for this record change
    string entityName?;
    # Identifies the sequence of the change within a transaction
    int sequenceNumber?;
    # The ID of the user that ran the change operation
    string commitUser?;
    # The system change number (SCN) of a committed transaction
    int commitNumber?;
    # The record ID for the changed record
    string recordId?;
};
