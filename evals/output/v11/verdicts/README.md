# Round seven verdicts

`key.tsv` is the arm assignment `pair.sh` produced for this round — which of
`A.md` and `B.md` was ours for each item. No judge saw it.

`judge-1.tsv`, `judge-2.tsv`, `judge-3.tsv` are the raw votes, as letters, in
the order the judges were run. Judge three was consulted only on the four items
where the first two disagreed, which is verdict-identical to running it
everywhere; see `evals/repair-protocol.md` §3.

Judge one answered the long prompt used in rounds one to six; judges two and
three answered the terse form. That inconsistency is a defect of this round and
is recorded in the protocol, which now standardises all three on the terse form.

Recomputing the tally:

    awk -F'\t' '
      FILENAME ~ /key/ { if (FNR>1) { a[$1]=$2; b[$1]=$3 }; next }
      FNR==1 { next }
      { v = ($2=="A") ? a[$1] : b[$1]
        n[$1]++; if (v ~ /v11/) ours[$1]++ }
      END { for (k in n) if (ours[k]*2 > n[k]) w++; else l++
            printf "%d-%d\n", w, l }' key.tsv judge-*.tsv
