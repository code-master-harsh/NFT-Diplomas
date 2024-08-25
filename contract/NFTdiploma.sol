// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BasicERC721 {
    // Events
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event DiplomaValidityUpdated(uint256 indexed tokenId, bool isValid);

    // State variables
    string public name = "NFT Diploma";
    string public symbol = "DIPLOMA";
    uint256 private _totalSupply;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => string) private _diplomaDetails;
    mapping(uint256 => bool) private _diplomaValidity; // Validity status of diplomas
    address private _owner; // Contract owner address

    // Constructor
    constructor() {
        _owner = msg.sender; // Set contract deployer as owner
    }

    // Modifier to check if the caller is the contract owner
    modifier onlyOwner() {
        require(msg.sender == _owner, "Not authorized");
        _;
    }

    // Function to mint a new diploma NFT
    function mintDiploma(address recipient, string memory diplomaDetail) external onlyOwner returns (uint256) {
        require(recipient != address(0), "Cannot mint to the zero address");

        uint256 tokenId = _totalSupply;
        _owners[tokenId] = recipient;
        _balances[recipient] += 1;
        _totalSupply += 1;
        _diplomaDetails[tokenId] = diplomaDetail;
        _diplomaValidity[tokenId] = true; // Set diploma as valid by default

        emit Transfer(address(0), recipient, tokenId);

        return tokenId; // Return the tokenId of the minted diploma
    }

    // Function to get diploma details by token ID
    function getDiplomaDetails(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "ERC721: query for nonexistent token");
        return _diplomaDetails[tokenId];
    }

    // Function to check if a diploma is valid
    function isDiplomaValid(uint256 tokenId) external view returns (bool) {
        require(_exists(tokenId), "ERC721: query for nonexistent token");
        return _diplomaValidity[tokenId];
    }

    // Function to set the validity of a diploma
    function setDiplomaValidity(uint256 tokenId, bool isValid) external onlyOwner {
        require(_exists(tokenId), "ERC721: query for nonexistent token");
        _diplomaValidity[tokenId] = isValid;
        emit DiplomaValidityUpdated(tokenId, isValid);
    }

    // Function to check if a token exists
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    // Function to get the owner of a token
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: query for nonexistent token");
        return owner;
    }

    // Function to get the balance of an address
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }
}
