
enum enemyT{enemy1, enemy2}
enum enemyS{idle, move}

//Clickable variables
event_inherited();

clickableFunctionOnHover	= BasicOnHover;
clickableFunctionOnDehover	= BasicOnDehover;
clickableFunctionOnSelect	= -1;
clickableFunctionOnRelease	= -1;

enemyBasicActionScript = EnemyMove;
enemyLastActionScript = EnemyAttack;

enemyHitScript = EnemyHit;

enemyGridPos = [-1, -1];
enemyGridPosNext = [-1, -1];
enemyGamePos = [-1, -1];

enemyCounter = 1;
enemyType = -1;

enemyAngle = random_range(-4, 4);

enemyHealth = irandom_range(1, 3);
enemyCurrentHealth = enemyHealth;
enemyHealthCounter = -1;