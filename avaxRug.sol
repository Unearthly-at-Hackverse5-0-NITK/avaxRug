/*The Code for RugPull Identification via 3 major factors 
1)Fake Volume Detection
2)Major Companies Backed up by.
3)Checking for the recent transactions.

Here is the code...
*/



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RugPullDetection {
    // Owner of the contract
    address public owner;

    // Event to log detection results
    event RugPullEvaluated(
        string projectName,
        uint256 score,
        string classification
    );

    // Struct to hold project details
    struct Project {
        string name;
        uint256 fakeVolumeScore; // Score based on fake volume creation
        uint256 recentTransactionsScore; // Score based on recent transactions
        uint256 backingScore; // Score based on company backing
        uint256 finalScore; // Final computed score
        string classification; // "Rug Pull" or "Trustworthy"
    }

    // Mapping to store projects
    mapping(string => Project) public projects;

    // Modifier to restrict function access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // Constructor to initialize the contract owner
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Evaluate a project based on given scores
     * @param _name Name of the project
     * @param _fakeVolumeScore Score for fake volume creation (0-40)
     * @param _recentTransactionsScore Score for recent transactions (0-30)
     * @param _backingScore Score for major company backing (0-30)
     */
    function evaluateProject(
        string memory _name,
        uint256 _fakeVolumeScore,
        uint256 _recentTransactionsScore,
        uint256 _backingScore
    ) public onlyOwner {
        require(
            _fakeVolumeScore <= 40 &&
            _recentTransactionsScore <= 30 &&
            _backingScore <= 30,
            "Invalid scores"
        );

        uint256 finalScore = _fakeVolumeScore +
            _recentTransactionsScore +
            _backingScore;

        string memory classification;
        if (finalScore < 60) {
            classification = "Most Likely a Rug Pull";
        } else {
            classification = "Trustworthy";
        }

        // Store the project details
        projects[_name] = Project({
            name: _name,
            fakeVolumeScore: _fakeVolumeScore,
            recentTransactionsScore: _recentTransactionsScore,
            backingScore: _backingScore,
            finalScore: finalScore,
            classification: classification
        });

        // Emit the result
        emit RugPullEvaluated(_name, finalScore, classification);
    }

    /**
     * @dev Retrieve project details
     * @param _name Name of the project
     * @return Project details including scores and classification
     */
    function getProjectDetails(string memory _name)
        public
        view
        returns (Project memory)
    {
        return projects[_name];
    }
}