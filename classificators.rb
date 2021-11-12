module Classificators
  TYPE_TO_TITLE = {
    'notice_concluded_contract' => 'Informatīvs paziņojums par noslēgto līgumu',
    'notice_contract_rights' => 'Paziņojums par iepirkuma procedūras rezultātiem',
    'notice_exante' => 'Brīvprātīgs paziņojums par iepirkuma rezultātiem',
    'notice_contract_rights_sps' => 'Paziņojums par iepirkuma procedūras rezultātiem - sabiedriskie pakalpojumi',
    'sps_notice_exante' => 'Brīvprātīgs paziņojums par iepirkuma rezultātiem - sabiedriskie pakalpojumi'
  }

  COUNTRIES = {
    1 =>  'Latvija',
    4 =>  'Afganistāna',
    7 =>  'Albānija',
    60  =>  'Alžīrija',
    222 =>  'Amerikas Savienotās Valstis',
    2 =>  'Andora',
    6 =>  'Angilja',
    10  =>  'Angola',
    5 =>  'Antigva un Barbuda',
    3 =>  'Apvienotie Arābu Emirāti',
    12  =>  'Argentīna',
    8 =>  'Armēnija',
    16  =>  'Aruba',
    221 =>  'ASV Mazās Aizjūras salas',
    13  =>  'ASV Samoa',
    229 =>  'ASV Virdžīnas',
    15  =>  'Austrālija',
    14  =>  'Austrija',
    213 =>  'Austrumtimora',
    17  =>  'Azerbaidžāna',
    31  =>  'Bahamu salas',
    24  =>  'Bahreina',
    35  =>  'Baltkrievija',
    20  =>  'Bangladeša',
    19  =>  'Barbadosa',
    36  =>  'Belize',
    21  =>  'Beļģija',
    26  =>  'Benina',
    27  =>  'Bermudu salas',
    29  =>  'Bolīvija',
    18  =>  'Bosnija un Hercegovina',
    34  =>  'Botsvāna',
    30  =>  'Brazīlija',
    228 =>  'Britu Virdžīnas',
    28  =>  'Bruneja',
    23  =>  'Bulgārija',
    22  =>  'Burkinafaso',
    25  =>  'Burundija',
    32  =>  'Butāna',
    33  =>  'Buvē sala',
    40  =>  'Centrālāfrikas Republika',
    204 =>  'Čada',
    54  =>  'Čehija',
    45  =>  'Čīle',
    57  =>  'Dānija',
    237 =>  'Dienvidāfrika',
    87  =>  'Dienviddžordžija un Dienvidsendviču salas',
    117 =>  'Dienvidkoreja',
    58  =>  'Dominika',
    59  =>  'Dominikāna',
    240 =>  'Džērsija',
    56  =>  'Džibutija',
    63  =>  'Ēģipte',
    61  =>  'Ekvadora',
    85  =>  'Ekvatoriālā Gvineja',
    65  =>  'Eritreja',
    67  =>  'Etiopija',
    72  =>  'Fēru salas',
    69  =>  'Fidži',
    169 =>  'Filipīnas',
    70  =>  'Folklenda (Malvinu) salas',
    73  =>  'Francija',
    205 =>  'Francijas Dienvidjūru teritorija',
    78  =>  'Francijas Gviāna',
    167 =>  'Francijas Polinēzija',
    74  =>  'Gabona',
    91  =>  'Gajāna',
    82  =>  'Gambija',
    79  =>  'Gana',
    241 =>  'Gērnsija',
    80  =>  'Gibraltārs',
    76  =>  'Grenāda',
    81  =>  'Grenlande',
    86  =>  'Grieķija',
    77  =>  'Gruzija',
    89  =>  'Guama',
    84  =>  'Gvadelupa',
    88  =>  'Gvatemala',
    83  =>  'Gvineja',
    90  =>  'Gvineja-Bisava',
    96  =>  'Haiti',
    93  =>  'Hērda sala un Makdonalda salas',
    94  =>  'Hondurasa',
    92  =>  'Honkonga',
    95  =>  'Horvātija',
    62  =>  'Igaunija',
    101 =>  'Indija',
    102 =>  'Indijas okeāna Britu teritorija',
    98  =>  'Indonēzija',
    103 =>  'Irāka',
    104 =>  'Irāna',
    99  =>  'Īrija',
    105 =>  'Īslande',
    106 =>  'Itālija',
    100 =>  'Izraēla',
    107 =>  'Jamaika',
    109 =>  'Japāna',
    153 =>  'Jaunkaledonija',
    163 =>  'Jaunzēlande',
    234 =>  'Jemena',
    108 =>  'Jordānija',
    51  =>  'Kaboverde',
    119 =>  'Kaimanu salas',
    112 =>  'Kambodža',
    46  =>  'Kamerūna',
    37  =>  'Kanāda',
    179 =>  'Katara',
    120 =>  'Kazahstāna',
    110 =>  'Kenija',
    53  =>  'Kipra',
    111 =>  'Kirgizstāna',
    113 =>  'Kiribati',
    38  =>  'Kokosu (Kīlinga) salas',
    48  =>  'Kolumbija',
    114 =>  'Komoru salas',
    41  =>  'Kongo',
    39  =>  'Kongo Demokrātiskā Republika',
    49  =>  'Kostarika',
    43  =>  'Kotdivuāra',
    182 =>  'Krievija',
    50  =>  'Kuba',
    44  =>  'Kuka salas',
    118 =>  'Kuveita',
    47  =>  'Ķīna',
    121 =>  'Laosa',
    127 =>  'Lesoto',
    122 =>  'Libāna',
    126 =>  'Libērija',
    130 =>  'Lībija',
    75  =>  'Lielbritānija',
    128 =>  'Lietuva',
    124 =>  'Lihtenšteina',
    129 =>  'Luksemburga',
    134 =>  'Madagaskara',
    235 =>  'Majota',
    140 =>  'Makao',
    136 =>  'Maķedonija',
    150 =>  'Malaizija',
    148 =>  'Malāvija',
    147 =>  'Maldīvija',
    137 =>  'Mali',
    145 =>  'Malta',
    131 =>  'Maroka',
    135 =>  'Māršala salas',
    142 =>  'Martinika',
    146 =>  'Maurīcija',
    143 =>  'Mauritānija',
    149 =>  'Meksika',
    242 =>  'Melnkalne',
    243 =>  'Mena',
    71  =>  'Mikronēzija',
    138 =>  'Mjanma',
    133 =>  'Moldova',
    132 =>  'Monako',
    139 =>  'Mongolija',
    144 =>  'Montserrata',
    151 =>  'Mozambika',
    152 =>  'Namībija',
    161 =>  'Nauru',
    160 =>  'Nepāla',
    158 =>  'Nīderlande',
    9 =>  'Nīderlandes Antiļas',
    154 =>  'Nigēra',
    156 =>  'Nigērija',
    157 =>  'Nikaragva',
    162 =>  'Niue',
    155 =>  'Norfolkas sala',
    159 =>  'Norvēģija',
    244 =>  'Olandes salas',
    164 =>  'Omāna',
    170 =>  'Pakistāna',
    177 =>  'Palau',
    175 =>  'Palestīna',
    165 =>  'Panama',
    168 =>  'Papua-Jaungvineja',
    178 =>  'Paragvaja',
    166 =>  'Peru',
    173 =>  'Pitkērna',
    171 =>  'Polija',
    176 =>  'Portugāle',
    174 =>  'Puertoriko',
    180 =>  'Reinjona',
    64  =>  'Rietumsahāra',
    233 =>  'Rietumsamoa',
    183 =>  'Ruanda',
    181 =>  'Rumānija',
    200 =>  'Salvadora',
    195 =>  'Sanmarīno',
    199 =>  'Santome un Prinsipi',
    184 =>  'Saūda Arābija',
    186 =>  'Seišelu salas',
    196 =>  'Senegāla',
    172 =>  'Senpjēra un Mikelona',
    115 =>  'Sentkitsa un Nevisa',
    123 =>  'Sentlūsija',
    226 =>  'Sentvinsenta un Grenadīnas',
    245 =>  'Serbija',
    189 =>  'Singapūra',
    201 =>  'Sīrija',
    194 =>  'Sjerraleone',
    193 =>  'Slovākija',
    191 =>  'Slovēnija',
    197 =>  'Somālija',
    68  =>  'Somija',
    66  =>  'Spānija',
    187 =>  'Sudāna',
    198 =>  'Surinama',
    190 =>  'Sv.Helēnas sala',
    192 =>  'Svalbāras arhipelāgs un Jana Majena sala',
    202 =>  'Svazilenda',
    125 =>  'Šrilanka',
    42  =>  'Šveice',
    208 =>  'Tadžikistāna',
    217 =>  'Taivāna',
    207 =>  'Taizeme',
    218 =>  'Tanzānija',
    203 =>  'Tērksas un Kaikosas salas',
    206 =>  'Togo',
    209 =>  'Tokelau',
    212 =>  'Tonga',
    215 =>  'Trinidāda un Tobāgo',
    211 =>  'Tunisija',
    214 =>  'Turcija',
    210 =>  'Turkmenistāna',
    216 =>  'Tuvalu',
    220 =>  'Uganda',
    219 =>  'Ukraina',
    97  =>  'Ungārija',
    223 =>  'Urugvaja',
    224 =>  'Uzbekistāna',
    55  =>  'Vācija',
    231 =>  'Vanuatu',
    225 =>  'Vatikāns (Svētais Krēsls)',
    227 =>  'Venecuēla',
    230 =>  'Vjetnama',
    232 =>  'Volisa un Futunas salas',
    185 =>  'Zālamana salas',
    238 =>  'Zambija',
    116 =>  'Ziemeļkoreja',
    141 =>  'Ziemeļu Marianas salas',
    52  =>  'Ziemsvētku sala',
    239 =>  'Zimbabve',
    188 =>  'Zviedrija'
  }

  CURRENCIES = {
    1 => 'LVL',
    2 => 'EUR',
    3 => 'USD',
    4 => 'GBP',
    5 => 'ISK',
    6 => 'LTL',
    7 => 'CHF',
    8 => 'SEK',
    9 => 'JPY',
    10 => 'NOK',
    11 => 'MTL',
    12 => 'EEK',
    13 => 'CYP',
    14 => 'SKK',
    15 => 'RON',
    16 => 'CZK',
    17 => 'DKK',
    18 => 'PLN',
    19 => 'BGN',
    20 => 'HUF',
    21 => 'MKD',
    22 => 'TRY',
    23 => 'HRK'
  }
end
