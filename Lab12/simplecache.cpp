#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  std::vector<SimpleCacheBlock> &block = _cache[index];
  for(int i = 0; i < block.size(); i++){
    if(block[i].valid() == 1 && block[i].tag() == tag){
      return block[i].get_byte(block_offset);
    }
}
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in in C++ (hint: Rule of Three)
  std::vector<SimpleCacheBlock> &block = _cache[index];
  for(std::vector<SimpleCacheBlock>::iterator it = block.begin(); it != block.end(); it++){
    if(!it->valid()){
      it->replace(tag, data);
      return;
    }
  }
  block[0].replace(tag, data);
}
