Microcalculator cu microprocesorul 6502 (WDC).

Scop
====

    Crearea unui sistem capabil sa gestioneze dispozitive auxiliare printr-un set
de functii de baza. Pe masura ce proiectul merge mai departe se vor dezvolta si alte capacitati software.

Impartirea memoriei
===================

        +-----------+
        |           |
        |           |
        |           |
        |           | 
        |    RAM    |   [0x0000, 0x7FFF] (32 KiB)
        |           |
        |           |
        |           |
        |           |
        |           |
        +-----------+
        |   VIA     |   [0x8000, 0x800F] (16 B)
        +-----------+
        |   ACIA    |   [0x8010, 0x801F] (16 B)
        +-----------+
        |   LIBER   |   [0x8020, 0x802F] (16 B)
        +-----------+
        |   LIBER   |   [0x8030, 0x803F] (16 B)
        +-----------+
        |           |
        |           |
        |           |
        |           |
        |    ROM    |   [0x8040, 0xFFFF] (32704 B)
        |           | 
        |           |
        |           |
        |           |
        +-----------+

    O alta varianta ar fi inclus folosirea unui sistem de banking, doar ca resursele
de memorie de care sistemul ar fi beneficiat ar fi fost mult prea generoase
sau chiar inutile pentru scopul ce trebuie sa-l indeplineasca.
