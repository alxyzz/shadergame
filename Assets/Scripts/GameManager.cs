using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public Material RainOnGlass;
    public Material skybox;
    public Material wobbler;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    public GameObject winscr;
    public void Win()
    {
        winscr.SetActive(true);
    }


    IEnumerator delayedquit() {
        yield return new WaitForSecondsRealtime(15f);
        Application.Quit();
    }
    float rot =1;
    void SpinSkyBox()
    {
        rot += (1*Time.deltaTime);
        if (rot > 359) { rot = 1; }
        skybox.SetFloat("_Rotation", rot);
    }
    //float wob = 1;
    //void AnimateSkyWobble()
    //{
    //    wob += (1 * Time.deltaTime);
    //    if (rot > 359) { wob = 1; }
    //    wobbler.SetFloat("_Rotation", wob);
    //}
    // Update is called once per frame
    void Update()
    {
        SpinSkyBox();
    }
}
