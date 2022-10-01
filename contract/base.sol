// SPDX-License-Identifier: NONE

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract BaseContract is ERC721URIStorage, ERC721Enumerable {
    using Counters for Counters.Counter;
    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    Counters.Counter private _tokenIdCounter;
    mapping(uint256 => bool) public minted;
    // key is token id, value is community owner address.
    mapping(uint256 => address) public communityOwner;

    constructor() ERC721("Example Contract", "EXMPL") {
        _tokenIdCounter.increment();
    }

    function mint(uint256 tokenId, string memory _tokenURI) public payable {
        require(tokenId == _tokenIdCounter.current());
        _safeMint(msg.sender, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), _tokenURI);
        minted[_tokenIdCounter.current()] = true;
        _tokenIdCounter.increment();
    }

    function bulkMint(
        uint256 numberOfToken,
        uint256 tokenId,
        string memory _tokenURI
    ) public payable {
        require(tokenId == _tokenIdCounter.current());
        require(numberOfToken <= 100);
        for (uint256 i = 0; i < numberOfToken; i++) {
            uint256 id = tokenId + i;
            mint(id, _tokenURI);
        }
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        override(ERC721URIStorage)
    {
        super._setTokenURI(tokenId, _tokenURI);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function burn(uint256 tokenId) public {
        require(msg.sender == ownerOf(tokenId));
        _burn(tokenId);
        minted[tokenId] = false;
        communityOwner[tokenId] = address(0);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        if (interfaceId == _INTERFACE_ID_ERC2981) {
            return true;
        }

        return super.supportsInterface(interfaceId);
    }
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}