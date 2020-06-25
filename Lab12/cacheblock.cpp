#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t tag_bits = get_tag();
  uint32_t offset_bits = _cache_config.get_num_block_offset_bits();
  uint32_t index_bits = _cache_config.get_num_index_bits();

  tag_bits = tag_bits << index_bits;
  tag_bits = tag_bits + _index;
  tag_bits = tag_bits << offset_bits;
  return tag_bits;
}
