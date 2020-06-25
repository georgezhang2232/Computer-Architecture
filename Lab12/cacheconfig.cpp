#include "cacheconfig.h"
#include "utils.h"

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */
  uint32_t temp = size/associativity;
  uint32_t index = temp/block_size;
  int i = 0;
  int j = 0;

  for(;;i++){
    index = index/2;
    if(index < 1) break;
  }

  for(;;j++){
    block_size = block_size/2;
    if(block_size < 1) break;
  }
  _num_index_bits = i;
  _num_block_offset_bits = j;
  _num_tag_bits = 32 - j - i;

}
