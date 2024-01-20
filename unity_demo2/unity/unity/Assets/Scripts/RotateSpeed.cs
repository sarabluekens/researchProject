using System;
using System.Numerics;
using UnityEngine;
using FlutterUnityIntegration;
using UnityEngine.EventSystems;

public class RotateSpeed : MonoBehaviour, IEventSystemHandler
{
    [SerializeField]
    UnityEngine.Vector3 CustomRotateAmount;

    // Start is called before the first frame update
    void Start()
    {
        CustomRotateAmount = new UnityEngine.Vector3(10, 0, 0);
        if (UnityMessageManager.Instance == null)
        {
            Debug.LogError("UnityMessageManager is not properly initialized.");
        }
        else
        {
            UnityMessageManager.Instance.SendMessageToFlutter("The cube feels started.");
        }
    }

    // Update is called once per frame
    void Update()
    {
        UnityMessageManager.Instance.SendMessageToFlutter($"The cube feels updated1. {Input.touchCount} ");
        gameObject.transform.Rotate(CustomRotateAmount * Time.deltaTime * 10);

        // for (int i = 0; i < Input.touchCount; ++i)
        // {
        //     UnityMessageManager.Instance.SendMessageToFlutter("For loop started.");
        //     if (Input.GetTouch(i).phase.Equals(TouchPhase.Began))
        //     {
        //         UnityMessageManager.Instance.SendMessageToFlutter("touch input detected.");

        //         var hit = new RaycastHit();

        //         Ray ray = Camera.main.ScreenPointToRay(Input.GetTouch(i).position);

        //         if (Physics.Raycast(ray, out hit))
        //         {
        //             // This method is used to send data to Flutter
        //             UnityMessageManager.Instance.SendMessageToFlutter("The cube feels updated.");
        //         }
        //     }
        // }
    }

    // This method is called from Flutter
    public String SB_SetRotationSpeed(String message)
    {
        float value = float.Parse(message);
        UnityMessageManager.Instance.SendMessageToFlutter($"old value: {CustomRotateAmount}");
        CustomRotateAmount = new UnityEngine.Vector3(10, value, value);
        return "Unity: Rotation speed set to " + value;
    }
}

