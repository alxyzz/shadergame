using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WinOnEnter : MonoBehaviour
{


    public GameManager gm;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player") gm.Win();
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
