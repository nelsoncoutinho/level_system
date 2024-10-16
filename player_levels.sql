CREATE TABLE `player_levels` (
  `identifier` varchar(60) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `respect` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `player_levels`
  ADD PRIMARY KEY (`identifier`);
COMMIT;