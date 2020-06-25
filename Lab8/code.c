int 
dfs(int target, int i, int* tree) {
	if (i >= 127) {
		return -1;
	}
	if (target == tree[i]) {
		return 0;
	}

	int ret = dfs(target, 2 * i, tree);
	if (ret >= 0) {
		return ret + 1;
	}
	ret = dfs(target, 2 * i + 1, tree);
	if (ret >= 0) {
		return ret + 1;
	}
	return ret;
}



struct Puzzle {
    int NUM_ROWS;
    int NUM_COLS;
    char** board;
};


char floodfill (Puzzle* puzzle, char marker, int row, int col) {
    if (row < 0 || col < 0) {
        return marker;
    }

    if (row >= puzzle->NUM_ROWS || col >= puzzle->NUM_COLS) {
        return marker;
    }

    char ** board = puzzle->board;
    
    if (board[row][col] != '#') {
        return marker;
    }

    board[row][col] = marker;

    floodfill(puzzle, marker, row + 1, col + 1);
    floodfill(puzzle, marker, row + 1, col + 0);
    floodfill(puzzle, marker, row + 1, col - 1);

    floodfill(puzzle, marker, row, col + 1);
    floodfill(puzzle, marker, row, col - 1);

    floodfill(puzzle, marker, row - 1, col + 1);
    floodfill(puzzle, marker, row - 1, col + 0);
    floodfill(puzzle, marker, row - 1, col - 1);

    return marker + 1;
}

void islandfill(Puzzle* puzzle) {
    char marker = 'A';
    for (int i = 0; i < puzzle->NUM_ROWS; i++) {
        for (int j = 0; j < puzzle->NUM_COLS; j++) {
            marker = floodfill(puzzle,marker,i,j);
        }
    }
}



void 
floyd_warshall (int graph[6][6], int shortest_distance[6][6]) { 
    for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < 6; ++j) {
			if (i == j) {
				shortest_distance[i][j] = 0;
			} else {
				shortest_distance[i][j] = graph[i][j]; 
			}
		}
	}
    for (int k = 0; k < 6; k++) {
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 6; j++) {
				if (shortest_distance[i][k] + shortest_distance[k][j] < shortest_distance[i][j]) {
					shortest_distance[i][j] = shortest_distance[i][k] + shortest_distance[k][j]; 
				}
            } 
        } 
    } 
}