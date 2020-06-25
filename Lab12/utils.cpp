#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t offset_bits = cache_config.get_num_block_offset_bits();
  uint32_t index_bits = cache_config.get_num_index_bits();

  if ((offset_bits + index_bits) == 0){
    return address;
  }
  uint32_t new_address = address >> (offset_bits + index_bits);
  return new_address;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t offset_bits = cache_config.get_num_block_offset_bits();
  uint32_t tag_bits = cache_config.get_num_tag_bits();
  uint32_t new_address = address << tag_bits;
  if (tag_bits > 31) return 0;
  new_address = new_address >> (tag_bits + offset_bits);
  return new_address;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t index_bits = cache_config.get_num_index_bits();
  uint32_t tag_bits = cache_config.get_num_tag_bits();
  uint32_t total_bit = index_bits + tag_bits;
  uint32_t new_address = address << total_bit;
  new_address = new_address >> total_bit;

  if(tag_bits > 31) return 0;
  return new_address;
}
