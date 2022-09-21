// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

import ballerina/log;
import ballerinax/salesforce.bulk;
import ballerinax/salesforce;

public function main() returns error? {

    string batchId = "";

    // Create Salesforce client configuration by reading from config file.
    salesforce:ConnectionConfig sfConfig = {
        baseUrl: "<BASE_URL>",
        clientConfig: {
            clientId: "<CLIENT_ID>",
            clientSecret: "<CLIENT_SECRET>",
            refreshToken: "<REFESH_TOKEN>",
            refreshUrl: "<REFRESH_URL>"
        }
    };

    // Create Salesforce client.
    bulk:Client bulkClient = check new (sfConfig);

    json contacts = [
        {
            description: "Created_from_Ballerina_Sf_Bulk_API",
            FirstName: "Avenra",
            LastName: "Stanis",
            Title: "Software Engineer Level 1",
            Phone: "0475626670",
            Email: "remusArf@gmail.com",
            My_External_Id__c: "860"
        },
        {
            description: "Created_from_Ballerina_Sf_Bulk_API",
            FirstName: "Irma",
            LastName: "Martin",
            Title: "Software Engineer Level 1",
            Phone: "0465616170",
            Email: "irmaHel@gmail.com",
            My_External_Id__c: "861"
        }
    ];

    bulk:BulkJob|error insertJob = bulkClient->createJob("insert", "Contact", "JSON");

    if insertJob is bulk:BulkJob {
        error|bulk:BatchInfo batch = bulkClient->addBatch(insertJob, contacts);
        if batch is bulk:BatchInfo {
            string message = batch.id.length() > 0 ? "Batch Added Successfully" : "Failed to add the Batch";
            batchId = batch.id;
            log:printInfo(message + " : " + message + " " + batchId);
        } else {
            log:printError(batch.message());
        }

        //get job info
        error|bulk:JobInfo jobInfo = bulkClient->getJobInfo(insertJob);
        if jobInfo is bulk:JobInfo {
            string message = jobInfo.id.length() > 0 ? "Jon Info Received Successfully" : "Failed Retrieve Job Info";
            log:printInfo(message);
        } else {
            log:printError(jobInfo.message());
        }

        //get batch info
        error|bulk:BatchInfo batchInfo = bulkClient->getBatchInfo(insertJob, batchId);
        if batchInfo is bulk:BatchInfo {
            string message = batchInfo.id == batchId ? "Batch Info Received Successfully" : "Failed to Retrieve Batch Info";
            log:printInfo(message);
        } else {
            log:printError(batchInfo.message());
        }

        //get all batches
        error|bulk:BatchInfo[] batchInfoList = bulkClient->getAllBatches(insertJob);
        if batchInfoList is bulk:BatchInfo[] {
            string message = batchInfoList.length() == 1 ? "All Batches Received Successfully" : "Failed to Retrieve All Batches";
            log:printInfo(message);
        } else {
            log:printError(batchInfoList.message());
        }

        //get batch request
        var batchRequest = bulkClient->getBatchRequest(insertJob, batchId);
        if batchRequest is json {
            json[]|error batchRequestArr = <json[]>batchRequest;
            if batchRequestArr is json[] {
                string message = batchRequestArr.length() == 2 ? "Batch Request Received Successfully" : "Failed to Retrieve Batch Request";
                log:printInfo(message);
            } else {
                log:printError(batchRequestArr.message());
            }
        } else if batchRequest is error {
            log:printError(batchRequest.message());
        } else {
            log:printError(batchRequest.toString());
        }

        //get batch result
        var batchResult = bulkClient->getBatchResult(insertJob, batchId);
        if batchResult is bulk:Result[] {
            string message = batchResult.length() > 0 ? "Batch Result Received Successfully" : "Failed to Retrieve Batch Result";
            log:printInfo(message);
        } else if batchResult is error {
            log:printError(batchResult.message());
        } else {
            log:printError(batchResult.toString());
        }

        //close job
        error|bulk:JobInfo closedJob = bulkClient->closeJob(insertJob);
        if closedJob is bulk:JobInfo {
            string message = closedJob.state == "Closed" ? "Job Closed Successfully" : "Failed to Close the Job";
            log:printInfo(message);
        } else {
            log:printError(closedJob.message());
        }
    }
    else {
        log:printInfo(insertJob.message());
    }

}
