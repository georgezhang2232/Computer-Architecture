#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */
   const CacheConfig & temp = _cache->get_config();
   uint32_t index = extract_index(address,temp);
   std::vector<Cache::Block*> v = _cache->get_blocks_in_set(index);
   uint32_t tag_t = extract_tag(address,temp);
   for(int i = 0; i < v.size(); i++){
     if(v[i]->get_tag() == tag_t){
       if(v[i]->is_valid()){
       _hits++;
       return v[i];
       }
     }
 }
 return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
   const CacheConfig & temp = _cache->get_config();
   uint32_t index = extract_index(address,temp);
   std::vector<Cache::Block*> v = _cache->get_blocks_in_set(index);
   uint32_t tag_t = extract_tag(address,temp);
   uint32_t time_ = v[0]->get_last_used_time();
   int c;
   for(int i = 0; i < v.size();i++){
     if(!v[i]->is_valid()){
       v[i]->set_tag(tag_t);
       v[i]->read_data_from_memory(_memory);
       v[i]->mark_as_valid();
       v[i]->mark_as_clean();
       return v[i];
     }
     if(v[i]->get_last_used_time() <= time_){
       time_ = v[i]->get_last_used_time();
       c = i;
     }
  }
  if(v[c]->is_dirty()){
    v[c]->write_data_to_memory(_memory);
  }
  v[c]->mark_as_valid();
  v[c]->mark_as_clean();
  return v[c];
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
   Cache::Block * caching = find_block(address);
   if(caching == NULL) caching = bring_block_into_cache(address);
   const CacheConfig & config_ = _cache->get_config();
   caching->set_last_used_time((++_use_clock).get_count());
   uint32_t temp = extract_block_offset(address, config_);
   return caching->read_word_at_offset(temp);
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
   Cache::Block *temp = find_block(address);
   if (!temp) {
     if (_policy.is_write_allocate()){
       temp = bring_block_into_cache(address);
     }
     else {
       _memory->write_word(address, word);
       return;
     }
   }
 temp->set_last_used_time((++_use_clock).get_count());
 const CacheConfig &config_ = _cache->get_config();
 temp->write_word_at_offset(word, extract_block_offset(address, config_));
 if (_policy.is_write_back()){
   temp->mark_as_dirty();
  }
  else{
    temp->write_data_to_memory(_memory);
  }
}
